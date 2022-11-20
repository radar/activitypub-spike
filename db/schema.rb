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

ActiveRecord::Schema[7.0].define(version: 2022_11_20_015256) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followings", id: false, force: :cascade do |t|
    t.bigint "follower_id"
    t.bigint "actor_id"
    t.index ["actor_id"], name: "index_followings_on_actor_id"
    t.index ["follower_id"], name: "index_followings_on_follower_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.string "content"
    t.jsonb "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_notes_on_author_id"
  end

  create_table "received_messages", force: :cascade do |t|
    t.bigint "from_id"
    t.bigint "to_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "source_id", null: false
    t.index ["from_id"], name: "index_received_messages_on_from_id"
    t.index ["source_id"], name: "index_received_messages_on_source_id"
    t.index ["to_id"], name: "index_received_messages_on_to_id"
  end

  create_table "sent_messages", force: :cascade do |t|
    t.bigint "from_id"
    t.jsonb "to"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_sent_messages_on_from_id"
  end

  add_foreign_key "followings", "actors", column: "follower_id"
  add_foreign_key "notes", "actors", column: "author_id"
  add_foreign_key "received_messages", "actors", column: "from_id"
  add_foreign_key "received_messages", "actors", column: "to_id"
  add_foreign_key "received_messages", "sent_messages", column: "source_id"
  add_foreign_key "sent_messages", "actors", column: "from_id"
end
