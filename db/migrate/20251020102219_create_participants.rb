class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table "participants" do |t|
      t.string "full_name", null: false
      t.string "email", null: false, index: {unique: true}
      t.string "access_token", index: true

      t.string "ticket_type"

      t.integer "cloud_generations_count", null: false, default: 0
      t.integer "cloud_generations_quota", null: false, default: 5

      t.check_constraint "cloud_generations_count <= cloud_generations_quota", name: "cloud_generations_count_check"

      t.boolean "blocked", null: false, default: false
      t.boolean "email_notifications_enabled", null: false, default: true

      t.integer "invitations_count", null: false, default: 0

      t.timestamps
    end
  end
end
