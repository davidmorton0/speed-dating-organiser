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

ActiveRecord::Schema.define(version: 2022_02_18_122315) do

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
    t.bigint "organisation_id", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["organisation_id"], name: "index_admins_on_organisation_id"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "daters", force: :cascade do |t|
    t.string "name", limit: 128, null: false
    t.string "email", default: "", null: false
    t.string "phone_number", limit: 128, null: false
    t.string "gender", limit: 128, null: false
    t.bigint "event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "matches", default: [], array: true
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: 6
    t.datetime "invitation_sent_at", precision: 6
    t.datetime "invitation_accepted_at", precision: 6
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_daters_on_email", unique: true
    t.index ["event_id"], name: "index_daters_on_event_id"
    t.index ["invitation_token"], name: "index_daters_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_daters_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_daters_on_invited_by"
    t.index ["reset_password_token"], name: "index_daters_on_reset_password_token", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "title", limit: 128, null: false
    t.datetime "starts_at", precision: 6, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "rep_id"
    t.bigint "organisation_id", null: false
    t.integer "max_rounds", null: false
    t.index ["organisation_id"], name: "index_events_on_organisation_id"
    t.index ["rep_id"], name: "index_events_on_rep_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name", limit: 128, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reps", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "organisation_id", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: 6
    t.datetime "invitation_sent_at", precision: 6
    t.datetime "invitation_accepted_at", precision: 6
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_reps_on_email", unique: true
    t.index ["invitation_token"], name: "index_reps_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_reps_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_reps_on_invited_by"
    t.index ["organisation_id"], name: "index_reps_on_organisation_id"
    t.index ["reset_password_token"], name: "index_reps_on_reset_password_token", unique: true
  end

  create_table "speed_dates", force: :cascade do |t|
    t.bigint "event_id"
    t.integer "round"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "dater_id"
    t.bigint "datee_id"
    t.index ["datee_id"], name: "index_speed_dates_on_datee_id"
    t.index ["dater_id"], name: "index_speed_dates_on_dater_id"
    t.index ["event_id"], name: "index_speed_dates_on_event_id"
  end

  add_foreign_key "speed_dates", "events"
end
