class TramRoutesController < ApplicationController
  GLOB = Rails.root.join("public", "geojson/*.json")

  def index
    paths = Dir[GLOB].map do |path|
      name = File.basename(path).split(".").first
      tram_route_path(name)
    end
    render json: paths
  end

  def show
    route_id = params[:id].gsub(/[^0-9a-z ]/i, "")
    path = Rails.root.join("public", "geojson", "#{route_id}.json")
    # binding.pry
    send_file path.to_s, disposition: :inline, content_type: :json
  end
end
