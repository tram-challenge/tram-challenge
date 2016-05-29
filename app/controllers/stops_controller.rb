class StopsController < ApplicationController
  set_tab :stops

  def index
    @stops = Stop.active.order(:name)
  end
end
