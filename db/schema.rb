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

ActiveRecord::Schema[7.0].define(version: 2023_01_08_145132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "folder_favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "folder_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_folder_favorites_on_folder_id"
    t.index ["user_id", "folder_id"], name: "index_folder_favorites_on_user_id_and_folder_id", unique: true
    t.index ["user_id"], name: "index_folder_favorites_on_user_id"
  end

  create_table "folder_taggings", force: :cascade do |t|
    t.bigint "folder_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id", "tag_id"], name: "index_folder_taggings_on_folder_id_and_tag_id", unique: true
    t.index ["folder_id"], name: "index_folder_taggings_on_folder_id"
    t.index ["tag_id"], name: "index_folder_taggings_on_tag_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "color"
    t.string "icon"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.text "url", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "folder_id", null: false
    t.text "image_url"
    t.index ["folder_id"], name: "index_links_on_folder_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "folder_favorites", "folders"
  add_foreign_key "folder_favorites", "users"
  add_foreign_key "folder_taggings", "folders"
  add_foreign_key "folder_taggings", "tags"
  add_foreign_key "folders", "users"
  add_foreign_key "links", "folders"
  add_foreign_key "links", "users"
end
