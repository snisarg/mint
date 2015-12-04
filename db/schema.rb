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

ActiveRecord::Schema.define(version: 20151105191932) do

  create_table "hashtag_lists", force: :cascade do |t|
    t.integer  "FK_tweet_id",   limit: 4
    t.integer  "FK_hashtag_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "hashtag_lists", ["FK_hashtag_id"], name: "fk_rails_2d5650397e", using: :btree
  add_index "hashtag_lists", ["FK_tweet_id"], name: "fk_rails_00643b388d", using: :btree

  create_table "hashtags", force: :cascade do |t|
    t.text     "text",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "mentions", force: :cascade do |t|
    t.integer  "FK_tweet_id", limit: 4
    t.integer  "FK_user_id",  limit: 8
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "mentions", ["FK_tweet_id"], name: "fk_rails_0c17d58473", using: :btree
  add_index "mentions", ["FK_user_id"], name: "fk_rails_a860b4e3eb", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.text     "text",                  limit: 65535
    t.float    "latitude",              limit: 24
    t.float    "longitude",             limit: 24
    t.text     "country_code",          limit: 65535
    t.text     "location_full_name",    limit: 65535
    t.integer  "FK_user_id",            limit: 8
    t.integer  "in_reply_to_user_id",   limit: 8
    t.integer  "in_reply_to_status_id", limit: 8
    t.integer  "retweet_count",         limit: 4
    t.integer  "favorite_count",        limit: 4
    t.text     "timestamp",             limit: 65535
    t.text     "source",                limit: 65535
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "tweets", ["FK_user_id"], name: "fk_rails_8f05ad24b0", using: :btree
  add_index "tweets", ["latitude", "longitude"], name: "index_tweets_on_latitude_and_longitude", using: :btree

  create_table "users", primary_key: "twitter_id", force: :cascade do |t|
    t.text     "name",        limit: 65535
    t.text     "screen_name", limit: 65535
    t.text     "location",    limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_foreign_key "hashtag_lists", "hashtags", column: "FK_hashtag_id"
  add_foreign_key "hashtag_lists", "tweets", column: "FK_tweet_id"
  add_foreign_key "mentions", "tweets", column: "FK_tweet_id"
  add_foreign_key "mentions", "users", column: "FK_user_id", primary_key: "twitter_id"
  add_foreign_key "tweets", "users", column: "FK_user_id", primary_key: "twitter_id"
end
