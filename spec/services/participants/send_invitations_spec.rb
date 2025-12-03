require "rails_helper"

describe Participants::SendInvitations do
  subject(:send) do
    described_class.new(participants: [participant], resend: resend).call
  end

  let_it_be(:participant) { create(:participant) }

  describe "#call" do
    let(:resend) { false }

    context 'when already send' do
      before_all { participant.invitations.create! }

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
