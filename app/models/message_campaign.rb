class MessageCampaign < ApplicationRecord
  validates :subject, :body, presence: true
end
