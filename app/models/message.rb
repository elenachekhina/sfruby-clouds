class Message < ApplicationRecord
  belongs_to :participant
  belongs_to :message_campaign, counter_cache: :sent_messages_count

  enum :status, %w[sent opened bounced].index_by(&:itself)

  delegate :subject, :body, to: :message_campaign

  after_create_commit do
    ParticipantMailer.with(campaign: message_campaign, participant:, trackable: self).campaign.deliver_later
  end

  after_update_commit :update_campaign_stats, if: :saved_change_to_status?

  private

  def update_campaign_stats
    case status
    when "opened"
      message_campaign.increment!(:opened_messages_count)
    when "bounced"
      message_campaign.increment!(:bounced_messages_count)
    end
  end
end
