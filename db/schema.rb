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

ActiveRecord::Schema.define(version: 20160528104354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "attempt_stops", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "attempt_id"
    t.uuid     "stop_id"
    t.time     "visited_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attempt_id"], name: "index_attempt_stops_on_attempt_id", using: :btree
    t.index ["stop_id"], name: "index_attempt_stops_on_stop_id", using: :btree
  end

  create_table "attempts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "player_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["player_id"], name: "index_attempts_on_player_id", using: :btree
  end

  create_table "players", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "icloud_user_id"
    t.string   "nickname"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["icloud_user_id"], name: "index_players_on_icloud_user_id", unique: true, using: :btree
  end

  create_table "stops", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.decimal  "longitude",    precision: 18, scale: 15
    t.decimal  "latitude",     precision: 18, scale: 15
    t.string   "name"
    t.string   "stop_numbers",                           default: [],                array: true
    t.string   "hsl_ids",                                default: [],                array: true
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "routes",                                 default: [],                array: true
    t.boolean  "active",                                 default: true
    t.index ["active"], name: "index_stops_on_active", using: :btree
    t.index ["hsl_ids"], name: "index_stops_on_hsl_ids", using: :gin
    t.index ["longitude", "latitude"], name: "index_stops_on_longitude_and_latitude", using: :btree
    t.index ["routes"], name: "index_stops_on_routes", using: :gin
    t.index ["stop_numbers"], name: "index_stops_on_stop_numbers", using: :gin
  end

  add_foreign_key "attempt_stops", "attempts"
  add_foreign_key "attempt_stops", "stops"
  add_foreign_key "attempts", "players"
end
