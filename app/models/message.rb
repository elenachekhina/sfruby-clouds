class Message < ApplicationRecord
  belongs_to :participant
  belongs_to :message_campaign, counter_cache: :sent_messages_count

  enum :status, %w[sent opened bounced].index_by(&:itself)

  delegate :subject, :body, to: :message_campaign

  after_create_commit do
    ParticipantMailer.with(campaign: self.message_campaign, participant: self.participant).campaign.deliver_later
  end
end
