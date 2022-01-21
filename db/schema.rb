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

ActiveRecord::Schema.define(version: 2022_01_21_175358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "daters", force: :cascade do |t|
    t.string "name", limit: 128, null: false
    t.string "email", limit: 128, null: false
    t.string "phone_number", limit: 128, null: false
    t.string "gender", limit: 128, null: false
    t.bigint "event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "matches", default: [], array: true
    t.index ["event_id"], name: "index_daters_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", limit: 128, null: false
    t.datetime "date", precision: 6, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "rep_id"
    t.index ["rep_id"], name: "index_events_on_rep_id"
  end

  create_table "reps", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_reps_on_email", unique: true
    t.index ["reset_password_token"], name: "index_reps_on_reset_password_token", unique: true
  end

  create_table "speed_dates", force: :cascade do |t|
    t.bigint "dater1_id"
    t.bigint "dater2_id"
    t.bigint "event_id"
    t.integer "round"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dater1_id"], name: "index_speed_dates_on_dater1_id"
    t.index ["dater2_id"], name: "index_speed_dates_on_dater2_id"
    t.index ["event_id"], name: "index_speed_dates_on_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "speed_dates", "daters", column: "dater1_id"
  add_foreign_key "speed_dates", "daters", column: "dater2_id"
  add_foreign_key "speed_dates", "events"
end
