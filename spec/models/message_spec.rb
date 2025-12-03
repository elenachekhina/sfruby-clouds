require 'rails_helper'

RSpec.describe Message, type: :model do
  let_it_be(:message_campaign) { create(:message_campaign) }
  let_it_be(:participant) { create(:participant) }

  describe ".create" do
    it "updates the message_campaign count for sent_messages_count" do
      expect { message_campaign.messages.create!(participant:) }
        .to change { message_campaign.reload.sent_messages_count }.by(1)
    end

    it "enqueue an email delivery" do
      expect do
        message_campaign.messages.create!(participant:)
      end.to have_enqueued_mail(ParticipantMailer, :campaign)
    end
  end

  describe "message_campaign counters update" do
    let_it_be(:message) { message_campaign.messages.create!(participant:) }

    it "updates the message_campaign count for opened_messages_count" do
      expect { message.delivery.update!(status: "opened") }
        .to change { message_campaign.reload.opened_messages_count }.by(1)
    end

    it "updates the message_campaign count for bounced_messages_count" do
      expect { message.delivery.update!(status: "bounced") }
        .to change { message_campaign.reload.bounced_messages_count }.by(1)
    end
  end
end
