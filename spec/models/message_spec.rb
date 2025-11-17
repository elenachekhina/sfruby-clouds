require 'rails_helper'

RSpec.describe Message, type: :model do
  let_it_be(:message_campaign) { create(:message_campaign) }
  let_it_be(:recipient) { create(:participant) }

  describe ".create" do
    it "updates the message_campaign count for sent_messages_count" do
      expect { message_campaign.messages.create!(recipient:) }
        .to change { message_campaign.reload.sent_messages_count }.by(1)
    end

    it "enqueue an email delivery" do
      expect do
        message_campaign.messages.create!(recipient:)
      end.to have_enqueued_mail(CampaignMailer, :mailing)
    end
  end
end
