module Participants
  class SendDeliverable
    attr_reader :participants, :resend

    def initialize(participants:, resend: false)
      @participants = participants
      @resend = resend
    end

    def call
      total_sent = 0

      participants.each do |participant|
        next if skip_participant?(participant)

        participant.deliveries.create!(deliverable:)

        total_sent += 1
      end

      total_sent
    end

    private

    def skip_participant?(participant)
      !participant.email_notifications_enabled? || (!resend && already_sent?(participant))
    end

    def already_sent?(participant)
      raise NotImplementedError, "Subclasses must implement already_sent?"
    end
  end
end
