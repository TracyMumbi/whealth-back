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

ActiveRecord::Schema[7.1].define(version: 2024_10_12_084102) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "date"
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["project_id"], name: "index_appointments_on_project_id"
  end

  create_table "consultants", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "gender"
    t.string "date_of_birth"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.string "speciality"
    t.string "board_number"
    t.integer "experience"
    t.boolean "is_client"
    t.boolean "is_consultant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.binary "file_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "appointment_id"
    t.index ["appointment_id"], name: "index_documents_on_appointment_id"
  end

  create_table "growths", force: :cascade do |t|
    t.decimal "weight"
    t.decimal "height"
    t.integer "age"
    t.decimal "length"
    t.integer "head_circumference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_growths_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "message"
    t.integer "appointment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_notifications_on_appointment_id"
  end

  create_table "otps", force: :cascade do |t|
    t.string "otp_no"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_otps_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "amount"
    t.integer "user_id", null: false
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_payments_on_project_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "status"
    t.integer "consultant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body"
    t.integer "amount"
    t.index ["consultant_id"], name: "index_projects_on_consultant_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "quills", force: :cascade do |t|
    t.text "content"
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_quills_on_project_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_code"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.string "gender"
    t.string "date_of_birth"
    t.string "username"
    t.boolean "is_client"
    t.boolean "is_consultant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "subscription_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "projects"
  add_foreign_key "documents", "appointments"
  add_foreign_key "growths", "users"
  add_foreign_key "notifications", "appointments"
  add_foreign_key "otps", "users"
  add_foreign_key "payments", "projects"
  add_foreign_key "payments", "users"
  add_foreign_key "projects", "consultants"
  add_foreign_key "projects", "users"
  add_foreign_key "quills", "projects"
  add_foreign_key "transactions", "users"
end
