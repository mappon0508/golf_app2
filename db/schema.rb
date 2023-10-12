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

ActiveRecord::Schema[7.0].define(version: 2023_10_11_130841) do
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
    t.index ["golf_course_id"], name: "index_golf_play_records_on_golf_course_id"
  end

  create_table "holes", force: :cascade do |t|
    t.integer "golf_course_id", null: false
    t.integer "number", null: false
    t.integer "par", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["golf_course_id"], name: "index_holes_on_golf_course_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "golf_courses", "users"
  add_foreign_key "golf_play_records", "golf_courses"
  add_foreign_key "holes", "golf_courses"
  add_foreign_key "scores", "golf_play_records"
  add_foreign_key "scores", "holes"
end
