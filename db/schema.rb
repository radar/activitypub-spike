# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_26_234350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "followings", id: false, force: :cascade do |t|
    t.bigint "follower_id"
    t.bigint "user_id"
    t.index ["follower_id"], name: "index_followings_on_follower_id"
    t.index ["user_id"], name: "index_followings_on_user_id"
  end

  create_table "received_messages", force: :cascade do |t|
    t.bigint "from_id"
    t.bigint "to_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_id"], name: "index_received_messages_on_from_id"
    t.index ["to_id"], name: "index_received_messages_on_to_id"
  end

  create_table "sent_messages", force: :cascade do |t|
    t.bigint "from_id"
    t.jsonb "to"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_id"], name: "index_sent_messages_on_from_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "followings", "users", column: "follower_id"
  add_foreign_key "received_messages", "users", column: "from_id"
  add_foreign_key "received_messages", "users", column: "to_id"
  add_foreign_key "sent_messages", "users", column: "from_id"
end
