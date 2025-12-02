module Webhooks
  class MandrillController < ApplicationController
    BOUNCED_EVENTS = %w[hard_bounce soft_bounce reject spam unsub invalid].freeze

    skip_before_action :verify_authenticity_token
    before_action :verify_mandrill_signature, only: [:create]

    def create
      events = JSON.parse(params[:mandrill_events]).select do
        (it["event"] == "open" || it["event"].in?(BOUNCED_EVENTS)) &&
          it.dig("msg", "metadata", "delivery_id").present?
      end.group_by { it.dig("msg", "metadata", "delivery_id") }

      Delivery.preload(:participant).where(id: events.keys).find_each do |delivery|
        events[delivery.id].each do |event|
          if event["event"] == "open"
            delivery.update!(status: :opened, opened_at: Time.zone.at(event["ts"]))
          else # bounced
            delivery.update!(status: :bounced, bounce_type: event["event"], bounced_at: Time.zone.at(event["ts"]))
            delivery.participant.update!(email_notifications_enabled: false)
          end
        end
      end

      head :ok
    end

    private

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
