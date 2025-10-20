class CreateClouds < ActiveRecord::Migration[8.1]
  def change
    create_table :clouds do |t|
      t.belongs_to :participant

      t.string :state, null: false, default: "uploaded"
      t.string :failure_reason

      t.boolean :picked, null: false, default: false

      t.timestamps
    end
  end
end
