class TramRoutesController < ApplicationController
  GLOB = Rails.root.join("public", "geojson/*.json")

  def index
    path = Rails.root.join("public", "geojson", "routes.json")
    send_file path, disposition: :inline, content_type: :json
  end
end
