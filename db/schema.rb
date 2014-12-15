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

ActiveRecord::Schema.define(version: 20141217000859) do

  create_table "clubs", force: true do |t|
    t.string   "name",        limit: 128, null: false
    t.string   "slug",        limit: 64,  null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", unique: true

  create_table "invitations", force: true do |t|
    t.string   "mail_address",                 null: false
    t.text     "message"
    t.integer  "club_id",                      null: false
    t.integer  "user_id"
    t.boolean  "admin",        default: false, null: false
    t.string   "token",                        null: false
    t.datetime "expired_at",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notice_read_users", force: true do |t|
    t.integer  "notice_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notice_read_users", ["notice_id"], name: "index_notice_read_users_on_notice_id"
  add_index "notice_read_users", ["user_id"], name: "index_notice_read_users_on_user_id"

  create_table "notices", force: true do |t|
    t.string   "title",                    null: false
    t.text     "body"
    t.integer  "user_id",                  null: false
    t.datetime "published_at"
    t.integer  "status",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notices", ["published_at"], name: "index_notices_on_published_at"
  add_index "notices", ["user_id"], name: "index_notices_on_user_id"

  create_table "read_notices_by_users", force: true do |t|
    t.integer "user_id"
    t.integer "notice_id"
  end

  add_index "read_notices_by_users", ["notice_id"], name: "index_read_notices_by_users_on_notice_id"
  add_index "read_notices_by_users", ["user_id"], name: "index_read_notices_by_users_on_user_id"

  create_table "replies", force: true do |t|
    t.integer  "notice_id",  null: false
    t.text     "body",       null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replies", ["notice_id"], name: "index_replies_on_notice_id"
  add_index "replies", ["user_id"], name: "index_replies_on_user_id"

  create_table "rs_evaluations", force: true do |t|
    t.string   "reputation_name"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.float    "value",           default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
  end

  add_index "rs_evaluations", ["reputation_name", "source_id", "source_type", "target_id", "target_type"], name: "index_rs_evaluations_on_reputation_name_and_source_and_target", unique: true
  add_index "rs_evaluations", ["reputation_name"], name: "index_rs_evaluations_on_reputation_name"
  add_index "rs_evaluations", ["source_id", "source_type"], name: "index_rs_evaluations_on_source_id_and_source_type"
  add_index "rs_evaluations", ["target_id", "target_type"], name: "index_rs_evaluations_on_target_id_and_target_type"

  create_table "rs_reputation_messages", force: true do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "receiver_id"
    t.float    "weight",      default: 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rs_reputation_messages", ["receiver_id", "sender_id", "sender_type"], name: "index_rs_reputation_messages_on_receiver_id_and_sender", unique: true
  add_index "rs_reputation_messages", ["receiver_id"], name: "index_rs_reputation_messages_on_receiver_id"
  add_index "rs_reputation_messages", ["sender_id", "sender_type"], name: "index_rs_reputation_messages_on_sender_id_and_sender_type"

  create_table "rs_reputations", force: true do |t|
    t.string   "reputation_name"
    t.float    "value",           default: 0.0
    t.string   "aggregated_by"
    t.integer  "target_id"
    t.string   "target_type"
    t.boolean  "active",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
  end

  add_index "rs_reputations", ["reputation_name", "target_id", "target_type"], name: "index_rs_reputations_on_reputation_name_and_target", unique: true
  add_index "rs_reputations", ["reputation_name"], name: "index_rs_reputations_on_reputation_name"
  add_index "rs_reputations", ["target_id", "target_type"], name: "index_rs_reputations_on_target_id_and_target_type"

  create_table "users", force: true do |t|
    t.string   "nickname"
    t.integer  "club_id",    default: 1,     null: false
    t.boolean  "admin",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_url"
  end

  add_index "users", ["club_id"], name: "index_users_on_club_id"

end
