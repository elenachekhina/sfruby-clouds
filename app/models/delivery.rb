class Delivery < ApplicationRecord
  delegated_type :deliverable, types: %w[Message], dependent: :destroy

  belongs_to :participant
  accepts_nested_attributes_for :deliverable

  enum :status, %w[sent opened bounced].index_by(&:itself)

  after_update_commit -> { deliverable.on_status_update }, if: :saved_change_to_status?
end
