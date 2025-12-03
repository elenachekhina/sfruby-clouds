module Participants
  class SendCampaignMessages < SendDeliverable
    attr_reader :message_campaign

    def initialize(participants:, message_campaign:, resend: false)
      super(participants: participants, resend: resend)
      @message_campaign = message_campaign
    end

    private

    def deliverable
      message_campaign.messages.new
    end

    def already_sent?(participant)
      participant.message_campaigns.include?(message_campaign)
    end
  end
end
