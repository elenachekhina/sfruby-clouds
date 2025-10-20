class CreateInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :invitations do |t|
      t.belongs_to :participant

      t.string :status, null: false, default: "sent"

      t.datetime :opened_at

      t.string :bounce_type
      t.datetime :bounced_at

      t.timestamps
    end
  end
end
