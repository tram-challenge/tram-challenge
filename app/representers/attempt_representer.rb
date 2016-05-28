require "roar/json"
require "roar/decorator"
require "roar/coercion"

class AttemptRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia
  include Roar::Coercion

  property :id

  property :started_at
  property :finished_at

  collection :attempt_stops, extend: AttemptStopRepresenter

  link :self do
     Rails.application.routes.url_helpers.api_attempt_path(represented)
  end
end
