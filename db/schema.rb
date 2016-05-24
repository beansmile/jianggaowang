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

ActiveRecord::Schema.define(version: 20160522020416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "collections", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "slide_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["user_id", "slide_id"], name: "index_collections_on_user_id_and_slide_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "header"
    t.text     "content"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "creator_id"
    t.string   "cover"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "venue"
    t.datetime "pinned_at"
    t.string   "editor_choice_title"
    t.string   "editor_choice_image"
    t.string   "slug"
  end

  add_index "events", ["creator_id"], name: "index_events_on_creator_id", using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "slide_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["slide_id", "user_id"], name: "index_likes_on_slide_id_and_user_id", using: :btree

  create_table "previews", force: :cascade do |t|
    t.integer  "slide_id"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
    t.string   "qiniu_file_path"
  end

  add_index "previews", ["slide_id"], name: "index_previews_on_slide_id", using: :btree

  create_table "slides", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "filename"
    t.integer  "user_id"
    t.boolean  "downloadable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visits_count",      default: 0
    t.integer  "likes_count",       default: 0
    t.integer  "collections_count", default: 0
    t.string   "file"
    t.integer  "event_id"
    t.integer  "status",            default: 0
    t.string   "author"
    t.string   "audio"
    t.string   "slug"
  end

  add_index "slides", ["slug"], name: "index_slides_on_slug", unique: true, using: :btree
  add_index "slides", ["user_id", "event_id"], name: "index_slides_on_user_id_and_event_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.text     "bio"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "approved_at"
  end

end
