require "roar/json"
require "roar/decorator"
require "roar/coercion"

class PlayerRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia
  include Roar::Coercion

  property :created_at
  property :updated_at

  property :icloud_user_id
  property :nickname

  link :self do
     Rails.application.routes.url_helpers.api_player_path
  end

  link :attempts do
    #  Rails.appliccation.routes.url_helpers.api_player_path
    "/api/attempts"
  end
end
