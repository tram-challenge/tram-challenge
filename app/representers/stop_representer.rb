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
  property :stop_positions

  link :self do
     Rails.application.routes.url_helpers.api_stop_path(represented)
  end
end
