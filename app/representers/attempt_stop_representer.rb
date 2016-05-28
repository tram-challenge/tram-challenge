require "roar/json"
require "roar/decorator"
require "roar/coercion"

class AttemptStopRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia
  include Roar::Coercion

  property :id

  property :visited_at

  property :stop, representer: StopRepresenter

  link :self do
    #  Rails.application.routes.url_helpers.api_attempt_stop_path(represented)
  end
end
