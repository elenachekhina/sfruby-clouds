module Webhooks
  class MandrillController < ApplicationController
    BOUNCED_EVENTS = %w[hard_bounce soft_bounce reject spam unsub invalid].freeze

    skip_before_action :verify_authenticity_token
    before_action :verify_mandrill_signature, only: [:create]

    def create
      events = JSON.parse(params[:mandrill_events]).select do
        (it["event"] == "open" || it["event"].in?(BOUNCED_EVENTS)) &&
          it.dig("metadata", "invitation_id").present?
      end.group_by { it["metadata"]["invitation_id"] }

      Invitation.preload(:participant).where(id: events.keys).find_each do |invitation|
        events[invitation.id].each do |event|
          if event["event"] == "open"
            invitation.update!(status: :opened, opened_at: Time.zone.at(event["ts"]))
          else # bounced
            invitation.update!(status: :bounced, bounce_type: event["event"], bounced_at: Time.zone.at(event["ts"]))
            invitation.participant.update!(email_notifications_enabled: false)
          end
        end
      end

      head :ok
    end

    private

    def verify_mandrill_signature
      # TODO?
    end
  end
end
