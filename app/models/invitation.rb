class Invitation < ApplicationRecord
  belongs_to :participant, counter_cache: true

  enum :status, %w[sent opened bounced].index_by(&:itself)

  after_create_commit do
    ParticipantMailer.with(participant:, invitation: self, trackable: self).welcome.deliver_later
  end
end
