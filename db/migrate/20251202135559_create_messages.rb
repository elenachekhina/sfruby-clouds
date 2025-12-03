class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.belongs_to :message_campaign, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
