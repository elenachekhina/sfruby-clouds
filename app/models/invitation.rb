class Invitation < ApplicationRecord
  include Deliverable

  after_create_commit do
    ParticipantMailer.with(participant:, invitation: self, delivery:).welcome.deliver_later
  end

  after_create_commit -> { participant.increment!(:invitations_count) }
  after_destroy_commit -> { participant.decrement!(:invitations_count) }
end
