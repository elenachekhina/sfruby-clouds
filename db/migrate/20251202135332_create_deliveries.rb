class CreateDeliveries < ActiveRecord::Migration[8.1]
  def change
    create_table :deliveries do |t|
      t.belongs_to :deliverable, polymorphic: true, null: false
      t.belongs_to :participant, null: false, foreign_key: true, index: true
      t.string :status, null: false, default: "sent"

      t.datetime :opened_at

      t.string :bounce_type
      t.datetime :bounced_at

      t.timestamps
    end
  end
end
