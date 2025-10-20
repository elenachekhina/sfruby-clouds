class Participant < ApplicationRecord
  extend FriendlyId

  friendly_id :full_name, use: :slugged

  has_many :invitations, dependent: :destroy
  has_many :clouds, dependent: :destroy

  has_one :picked_cloud, -> { picked }, class_name: "Cloud"

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :full_name, :email, presence: true
  validates :email, uniqueness: true

  before_create do
    self.access_token ||= Nanoid.generate(size: 6)
  end

  def cloud_generations_remained = cloud_generations_quota - cloud_generations_count

  def cloud_generations_remained? = cloud_generations_remained > 0
end
