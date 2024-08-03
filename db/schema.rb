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

ActiveRecord::Schema[7.1].define(version: 2024_08_01_203710) do
  create_table "assignations", force: :cascade do |t|
    t.date "date"
    t.string "start_time"
    t.string "end_time"
    t.integer "user_id"
    t.index ["user_id"], name: "index_assignations_on_user_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer "user_id"
    t.integer "assignation_id"
    t.boolean "enabled", default: false, null: false
    t.index ["assignation_id"], name: "index_availabilities_on_assignation_id"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assignations", "users"
  add_foreign_key "availabilities", "assignations"
  add_foreign_key "availabilities", "users"
end
