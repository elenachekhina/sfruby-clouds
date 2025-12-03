module Participants
  class SendInvitations < SendDeliverable
    private

    def deliverable
      Invitation.new
    end

    def already_sent?(participant)
      participant.invitations_count > 0
    end
  end
end
