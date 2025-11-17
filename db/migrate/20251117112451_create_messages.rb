class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.belongs_to :recipient, null: false, foreign_key: {to_table: :participants}, index: true
      t.belongs_to :message_campaign, null: false, foreign_key: true, index: true
      t.string :status, null: false, default: "sent"

      t.datetime :opened_at

      t.string :bounce_type
      t.datetime :bounced_at

      t.timestamps
    end
  end
end
