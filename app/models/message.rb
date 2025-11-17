class Message < ApplicationRecord
  belongs_to :recipient, class_name: "Participant"
  belongs_to :message_campaign, counter_cache: :sent_messages_count

  enum :status, %w[sent opened bounced].index_by(&:itself)

  delegate :subject, :body, to: :message_campaign
end
