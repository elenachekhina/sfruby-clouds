class Participant < ApplicationRecord
  extend FriendlyId

  friendly_id :full_name, use: [:slugged, :finders]

  has_many :deliveries, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :clouds, dependent: :destroy
  has_many :messages, through: :deliveries, source: :deliverable, source_type: "Message"

  has_one :picked_cloud, -> { picked }, class_name: "Cloud"

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :full_name, :email, presence: true
  validates :email, uniqueness: true

  scope :without_picked_cloud, -> { where.missing(:picked_cloud) }
  scope :without_invitations, -> { where.missing(:invitations) }
  scope :search, ->(q) { where(arel_table[:full_name].matches("%#{q}%").or(arel_table[:email].matches("%#{q}%"))) }

  before_create do
    self.access_token ||= Nanoid.generate(size: 6)
  end

  def cloud_generations_remained = cloud_generations_quota - cloud_generations_count

  def cloud_generations_remained? = cloud_generations_remained > 0
end
