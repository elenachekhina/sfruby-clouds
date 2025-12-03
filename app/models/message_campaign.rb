class MessageCampaign < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :name, :subject, :body, presence: true
end
