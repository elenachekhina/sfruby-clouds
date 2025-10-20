require "rails_helper"

describe Participant do
  let_it_be(:participant) { create(:participant) }

  describe ".create" do
    it "updates the invitations count for participant" do
      expect { participant.invitations.create! }.to change { participant.reload.invitations_count }.by(1)
    end

    it "enqueue an email delivery" do
      expect do
        participant.invitations.create!
      end.to have_enqueued_mail(ParticipantMailer, :welcome)
    end
  end
end
