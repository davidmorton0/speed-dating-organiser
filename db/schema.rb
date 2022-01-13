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

ActiveRecord::Schema.define(version: 2022_01_13_224445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daters", force: :cascade do |t|
    t.string "name", limit: 128, null: false
    t.string "email", limit: 128, null: false
    t.string "phone_number", limit: 128, null: false
    t.string "gender", limit: 128, null: false
    t.bigint "event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_daters_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", limit: 128, null: false
    t.datetime "date", precision: 6, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "speed_dates", force: :cascade do |t|
    t.integer "dater_1_id"
    t.integer "dater_2_id"
    t.integer "event_id"
    t.integer "round"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dater_1_id"], name: "index_speed_dates_on_dater_1_id"
    t.index ["dater_2_id"], name: "index_speed_dates_on_dater_2_id"
    t.index ["event_id"], name: "index_speed_dates_on_event_id"
  end

  add_foreign_key "speed_dates", "dater_1s"
  add_foreign_key "speed_dates", "dater_2s"
  add_foreign_key "speed_dates", "events"
end
