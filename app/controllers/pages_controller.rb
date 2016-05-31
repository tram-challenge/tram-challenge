class PagesController < ApplicationController
  TRAM_ROUTES = begin
    path = Rails.root.join("public", "geojson", "routes.json")
    File.read(path)
  end

  def home
    set_tab :home
  end

  def about
    set_tab :about
  end

  def rules
    set_tab :rules
  end

  def map
    @stops = Stop.active.order(:name)
  end
end
