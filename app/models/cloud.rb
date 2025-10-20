class Cloud < ApplicationRecord
  belongs_to :participant

  enum :state, %w[uploaded nsfw_checked generated failed].index_by(&:itself)

  has_one_attached :image
  has_one_attached :generated_image

  scope :picked, -> { where(picked: true) }
  scope :ordered, -> { order(created_at: :desc, id: :desc) }
end
