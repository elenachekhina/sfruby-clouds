module Webhooks
  class MandrillController < ApplicationController
    BOUNCED_EVENTS = %w[hard_bounce soft_bounce reject spam unsub invalid].freeze

    skip_before_action :verify_authenticity_token
    before_action :verify_mandrill_signature, only: [:create]

    def create
      events_by_type = JSON.parse(params[:mandrill_events]).select do
        (it["event"] == "open" || it["event"].in?(BOUNCED_EVENTS)) &&
          it.dig("msg", "metadata", "trackable_id").present? && it.dig("msg", "metadata", "trackable_type").present?
      end.group_by { it.dig("msg", "metadata", "trackable_type") }

      events_by_type.each do |trackable_type, events|
        klass = trackable_type.classify.constantize rescue nil
        next unless klass

        events = events.group_by { |it| it.dig("msg", "metadata", "trackable_id") }

        klass.preload(:participant).where(id: events.keys).find_each do |trackable|
          events[trackable.id].each do |event|
            process_event(trackable, event)
          end
        end
      end

      head :ok
    end

    private

    def process_event(trackable, event)
      if event["event"] == "open"
        trackable.update!(status: :opened, opened_at: Time.zone.at(event["ts"]))
      else # bounced
        trackable.update!(status: :bounced, bounce_type: event["event"], bounced_at: Time.zone.at(event["ts"]))
        trackable.participant.update!(email_notifications_enabled: false)
      end
    end

    # See https://mailchimp.com/developer/transactional/guides/track-respond-activity-webhooks/#authenticating-webhook-requests
    def verify_mandrill_signature
      webhook_key = MandrillConfig.webhook_key
      return unless webhook_key

      provided_signature = request.headers["X-Mandrill-Signature"]
      return head :unauthorized unless provided_signature

      signature_parts = [request.url]
      request.request_parameters.sort_by(&:first).each do |key, value|
        signature_parts << key.to_s
        signature_parts << value
      end

      expected_signature = Base64.encode64(OpenSSL::HMAC.digest("sha1", webhook_key, signature_parts.join)).strip

      unless provided_signature == expected_signature
        Rails.error.report(StandardError.new("Invalid Mandrill signature"), context: {provided_signature:, expected_signature:, signature_parts:})
        head :unauthorized
      end
    end
  end
end
