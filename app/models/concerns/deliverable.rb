module Deliverable
  extend ActiveSupport::Concern

  included do
    has_one :delivery, as: :deliverable, dependent: :destroy, touch: true
    has_one :participant, through: :delivery

    delegate :status, to: :delivery

    def on_status_update; end
  end
end