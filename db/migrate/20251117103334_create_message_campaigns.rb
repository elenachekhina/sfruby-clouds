class CreateMessageCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :message_campaigns do |t|
      t.string :name, null: false
      t.string :subject, null: false
      t.text :body, null: false
      t.integer :sent_messages_count, null: false, default: 0
      t.integer :opened_messages_count, null: false, default: 0
      t.integer :bounced_messages_count, null: false, default: 0

      t.timestamps
    end
  end
end
