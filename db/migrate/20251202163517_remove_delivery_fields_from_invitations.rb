class RemoveDeliveryFieldsFromInvitations < ActiveRecord::Migration[8.1]
  def change
    change_table :invitations do |t|
      t.remove :opened_at, :bounced_at, type: :datetime
      t.remove :status, type: :string, null: false, default: "sent"
      t.remove :bounce_type, type: :string
      t.remove_references :participant, foreign_key: true
    end
  end
end
