class Message < ApplicationRecord
  include Deliverable

  belongs_to :message_campaign, counter_cache: :sent_messages_count

  after_create_commit do
    ParticipantMailer.with(campaign: message_campaign, participant:, delivery:).campaign.deliver_later
  end

  def on_status_update
    message_campaign.increment!("#{status}_messages_count")
  end
end
