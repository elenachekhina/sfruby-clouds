# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_17_112451) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clouds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "failure_reason"
    t.integer "participant_id"
    t.boolean "picked", default: false, null: false
    t.string "state", default: "uploaded", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_clouds_on_participant_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "bounce_type"
    t.datetime "bounced_at"
    t.datetime "created_at", null: false
    t.datetime "opened_at"
    t.integer "participant_id"
    t.string "status", default: "sent", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_invitations_on_participant_id"
  end

  create_table "message_campaigns", force: :cascade do |t|
    t.text "body", null: false
    t.integer "bounced_messages_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "opened_messages_count", default: 0, null: false
    t.integer "sent_messages_count", default: 0, null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string "bounce_type"
    t.datetime "bounced_at"
    t.datetime "created_at", null: false
    t.integer "message_campaign_id", null: false
    t.datetime "opened_at"
    t.integer "recipient_id", null: false
    t.string "status", default: "sent", null: false
    t.datetime "updated_at", null: false
    t.index ["message_campaign_id"], name: "index_messages_on_message_campaign_id"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "access_token"
    t.boolean "blocked", default: false, null: false
    t.integer "cloud_generations_count", default: 0, null: false
    t.integer "cloud_generations_quota", default: 5, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "email_notifications_enabled", default: true, null: false
    t.string "full_name", null: false
    t.integer "invitations_count", default: 0, null: false
    t.string "slug"
    t.string "ticket_type"
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_participants_on_access_token"
    t.index ["email"], name: "index_participants_on_email", unique: true
    t.index ["slug"], name: "index_participants_on_slug", unique: true
    t.check_constraint "cloud_generations_count <= cloud_generations_quota", name: "cloud_generations_count_check"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "messages", "message_campaigns"
  add_foreign_key "messages", "participants", column: "recipient_id"
end
