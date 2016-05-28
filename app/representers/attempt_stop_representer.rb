require "roar/json"
require "roar/decorator"
require "roar/coercion"

class AttemptStopRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia
  include Roar::Coercion

  property :visited_at, render_nil: true
  property :stop_id, as: :id

  link :self do
    Rails.application.routes.url_helpers.api_stop_path(id: represented.stop_id)
  end
end
