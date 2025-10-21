class Cloud < ApplicationRecord
  belongs_to :participant, counter_cache: :cloud_generations_count

  enum :state, %w[uploaded analyzing analyzed generating generated failed].index_by(&:itself)

  has_one_attached :image
  has_one_attached :generated_image, service: :public_local

  scope :picked, -> { where(picked: true) }
  scope :ordered, -> { order(created_at: :desc, id: :desc) }
end
