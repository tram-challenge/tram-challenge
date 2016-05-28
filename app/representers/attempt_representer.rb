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
  property :elapsed_time
  property :current_time, writeable: false, getter: -> (_) { Time.current }, exec_context: :decorator

  collection :attempt_stops, as: :stops, extend: AttemptStopRepresenter

  link :self do
     Rails.application.routes.url_helpers.api_attempt_path(represented)
  end
end
