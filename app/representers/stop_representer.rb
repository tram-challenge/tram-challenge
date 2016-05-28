require "roar/json"
require "roar/decorator"
require "roar/coercion"

class StopRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia
  include Roar::Coercion

  property :id

  property :longitude
  property :latitude

  property :name
  property :stop_numbers
  property :hsl_ids
  property :routes

  link :self do
     Rails.application.routes.url_helpers.api_stop_path(represented)
  end
end

# create_table "stops", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
#   t.decimal  "longitude",    precision: 18, scale: 15
#   t.decimal  "latitude",     precision: 18, scale: 15
#   t.string   "name"
#   t.string   "stop_numbers",                           default: [],              array: true
#   t.string   "hsl_ids",                                default: [],              array: true
#   t.datetime "created_at",                                          null: false
#   t.datetime "updated_at",                                          null: false
#   t.index ["hsl_ids"], name: "index_stops_on_hsl_ids", using: :gin
#   t.index ["longitude", "latitude"], name: "index_stops_on_longitude_and_latitude", using: :btree
#   t.index ["stop_numbers"], name: "index_stops_on_stop_numbers", using: :gin
# end
