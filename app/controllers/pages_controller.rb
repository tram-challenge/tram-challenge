class PagesController < ApplicationController
  TRAM_ROUTES = begin
    path = Rails.root.join("public", "geojson", "routes.json")
    File.read(path)
  end

  before_action :set_cache_headers

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

  def suomeksi
    @lang = "fi"
    set_tab :suomeksi
  end

  private def set_cache_headers
    expires_in 1.minute, public: true
  end
end
