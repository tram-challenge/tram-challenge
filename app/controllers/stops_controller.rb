class StopsController < ApplicationController
  def index
    set_tab :stops
    @stops = Stop.active.order(:name)
  end
end
