require "rails_helper"

describe Participants::SendCampaignMessages do
  subject(:send) do
    described_class.new(participants: [participant], message_campaign: message_campaign, resend: resend).call
  end

  let_it_be(:participant) { create(:participant) }
  let_it_be(:message_campaign) { create(:message_campaign) }

  describe "#call" do
    let(:resend) { false }

    context 'when already send' do
      before_all { participant.messages.create! message_campaign: }

      context 'does not resend if resend is false' do
        it { expect(send).to eq(0) }
      end

      context 'resends if resend is true' do
        let(:resend) { true }

        it { expect(send).to eq(1) }
      end
    end

    context 'when not already sent' do
      it { expect(send).to eq(1) }
    end
  end
end
