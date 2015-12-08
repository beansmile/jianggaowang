# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151208134903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "slides_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "slide_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "slide_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "previews", force: :cascade do |t|
    t.integer  "slide_id"
    t.string   "filename",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slides", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "description",       limit: 255
    t.string   "filename",          limit: 255
    t.integer  "user_id"
    t.integer  "category_id"
    t.boolean  "downloadable"
    t.string   "persistent_id",     limit: 255
    t.string   "persistent_state",  limit: 255
    t.integer  "visits_count",                  default: 0
    t.integer  "likes_count",                   default: 0
    t.integer  "collections_count",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.text     "bio"
    t.string   "email",                           limit: 255
    t.string   "password_digest",                 limit: 255
    t.string   "avatar",                          limit: 255
    t.string   "reset_password_token",            limit: 255
    t.datetime "reset_password_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
