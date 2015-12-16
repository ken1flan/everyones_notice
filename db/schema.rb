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

ActiveRecord::Schema.define(version: 20150630163246) do

  create_table "activities", force: :cascade do |t|
    t.integer  "type_id"
    t.integer  "user_id"
    t.integer  "notice_id"
    t.integer  "reply_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "advertisement_id"
    t.integer  "activity_recordable_id"
    t.string   "activity_recordable_type"
  end

  add_index "activities", ["activity_recordable_type", "activity_recordable_id"], name: "index_activities_on_activity_recordable_reference"
  add_index "activities", ["created_at"], name: "index_activities_on_created_at"
  add_index "activities", ["notice_id"], name: "index_activities_on_notice_id"
  add_index "activities", ["reply_id"], name: "index_activities_on_reply_id"
  add_index "activities", ["type_id", "user_id", "notice_id", "reply_id"], name: "index_activities_unique_key", unique: true
  add_index "activities", ["type_id"], name: "index_activities_on_type_id"
  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "advertisements", force: :cascade do |t|
    t.string   "title",      null: false
    t.string   "summary",    null: false
    t.text     "body",       null: false
    t.date     "started_on", null: false
    t.date     "ended_on",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "advertisements", ["started_on", "ended_on"], name: "index_advertisements_on_started_on_and_ended_on"
  add_index "advertisements", ["updated_at"], name: "index_advertisements_on_updated_at"

  create_table "approvals", force: :cascade do |t|
    t.integer  "approvable_id"
    t.string   "approvable_type"
    t.integer  "user_id"
    t.boolean  "deleted",         default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "approvals", ["approvable_type", "approvable_id"], name: "index_approvals_on_approvable_type_and_approvable_id"
  add_index "approvals", ["user_id"], name: "index_approvals_on_user_id"

  create_table "clubs", force: :cascade do |t|
    t.string   "name",        limit: 128, null: false
    t.string   "slug",        limit: 64,  null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text     "body",                   null: false
    t.integer  "user_id",                null: false
    t.string   "url"
    t.integer  "status",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "feedbacks", ["status"], name: "index_feedbacks_on_status"
  add_index "feedbacks", ["updated_at"], name: "index_feedbacks_on_updated_at"
  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id"

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", unique: true

  create_table "invitations", force: :cascade do |t|
    t.string   "mail_address", limit: 255,                 null: false
    t.text     "message"
    t.integer  "club_id",                                  null: false
    t.integer  "user_id"
    t.boolean  "admin",                    default: false, null: false
    t.string   "token",        limit: 255,                 null: false
    t.datetime "expired_at",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notice_read_users", force: :cascade do |t|
    t.integer  "notice_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notice_read_users", ["notice_id"], name: "index_notice_read_users_on_notice_id"
  add_index "notice_read_users", ["user_id"], name: "index_notice_read_users_on_user_id"

  create_table "notice_tags", force: :cascade do |t|
    t.integer  "notice_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notice_tags", ["notice_id", "tag_id"], name: "index_notice_tags_on_notice_id_and_tag_id"
  add_index "notice_tags", ["tag_id", "notice_id"], name: "index_notice_tags_on_tag_id_and_notice_id"

  create_table "notices", force: :cascade do |t|
    t.string   "title",        limit: 255,             null: false
    t.text     "body"
    t.integer  "user_id",                              null: false
    t.datetime "published_at"
    t.integer  "status",                   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notices", ["published_at"], name: "index_notices_on_published_at"
  add_index "notices", ["user_id"], name: "index_notices_on_user_id"

  create_table "post_images", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "title",      null: false
    t.string   "image",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "post_images", ["created_at"], name: "index_post_images_on_created_at"
  add_index "post_images", ["user_id"], name: "index_post_images_on_user_id"

  create_table "read_notices_by_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "notice_id"
  end

  add_index "read_notices_by_users", ["notice_id"], name: "index_read_notices_by_users_on_notice_id"
  add_index "read_notices_by_users", ["user_id"], name: "index_read_notices_by_users_on_user_id"

  create_table "replies", force: :cascade do |t|
    t.integer  "notice_id",  null: false
    t.text     "body",       null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replies", ["notice_id"], name: "index_replies_on_notice_id"
  add_index "replies", ["user_id"], name: "index_replies_on_user_id"

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "nickname",     limit: 255
    t.integer  "club_id",                  default: 1,     null: false
    t.boolean  "admin",                    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_url",     limit: 255
    t.string   "belonging_to"
  end

  add_index "users", ["club_id"], name: "index_users_on_club_id"

end
