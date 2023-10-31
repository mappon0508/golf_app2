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

ActiveRecord::Schema[7.0].define(version: 2023_10_26_232245) do
  create_table "golf_courses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_golf_courses_on_user_id"
  end

  create_table "golf_play_records", force: :cascade do |t|
    t.integer "golf_course_id", null: false
    t.date "play_day", null: false
    t.integer "weather", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "finish", default: 0, null: false
    t.integer "user_id", null: false
    t.index ["golf_course_id"], name: "index_golf_play_records_on_golf_course_id"
    t.index ["user_id"], name: "index_golf_play_records_on_user_id"
  end

  create_table "holes", force: :cascade do |t|
    t.integer "golf_course_id", null: false
    t.integer "number", null: false
    t.integer "par", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["golf_course_id"], name: "index_holes_on_golf_course_id"
  end

  create_table "practice_days", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "practice_time"
    t.date "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "content"], name: "index_practice_days_on_user_id_and_content", unique: true
    t.index ["user_id"], name: "index_practice_days_on_user_id"
  end

  create_table "practice_menus", force: :cascade do |t|
    t.text "title"
    t.text "methods"
    t.text "objective"
    t.text "trick"
    t.integer "level", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0, null: false
    t.integer "practice_type", default: 0, null: false
  end

  create_table "practice_schedules", force: :cascade do |t|
    t.integer "practice_day_id", null: false
    t.integer "practice_menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_day_id"], name: "index_practice_schedules_on_practice_day_id"
    t.index ["practice_menu_id"], name: "index_practice_schedules_on_practice_menu_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "golf_play_record_id", null: false
    t.integer "content"
    t.integer "tee_shot", default: 0, null: false
    t.integer "second_shot_distance", default: 0, null: false
    t.integer "approach_shot", default: 0, null: false
    t.integer "approach", default: 0, null: false
    t.integer "bunker_save", default: 0, null: false
    t.integer "long_putt", default: 0, null: false
    t.integer "short_putt", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hole_id", null: false
    t.integer "putt"
    t.index ["golf_play_record_id"], name: "index_scores_on_golf_play_record_id"
    t.index ["hole_id"], name: "index_scores_on_hole_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.integer "gender", default: 0, null: false
    t.integer "golf_experience", null: false
    t.integer "best_score", null: false
    t.date "birthday", null: false
    t.string "remember_digest"
    t.integer "weak_point", default: 0, null: false
    t.integer "very_weak_point", default: 0, null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "golf_courses", "users"
  add_foreign_key "golf_play_records", "golf_courses"
  add_foreign_key "golf_play_records", "users"
  add_foreign_key "holes", "golf_courses"
  add_foreign_key "practice_days", "users"
  add_foreign_key "practice_schedules", "practice_days"
  add_foreign_key "practice_schedules", "practice_menus"
  add_foreign_key "scores", "golf_play_records"
  add_foreign_key "scores", "holes"
end
