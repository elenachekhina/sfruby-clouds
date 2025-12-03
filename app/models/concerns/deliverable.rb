module Deliverable
  extend ActiveSupport::Concern

  included do
    has_one :delivery, as: :deliverable, dependent: :destroy, touch: true
    has_one :participant, through: :delivery

    delegate :status, :opened_at, :bounced_at, :bounce_type, to: :delivery

    def on_status_update; end
  end
end
