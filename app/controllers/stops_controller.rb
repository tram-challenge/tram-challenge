class StopsController < ApplicationController
  def index
    set_tab :stops
    @stops = Stop.active.order(:name)

    respond_to do |format|
      format.html
      format.kml
      format.json
    end
  end
end
