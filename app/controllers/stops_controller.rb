class StopsController < ApplicationController
  def index
    @stops = Stop.active.order(:name)
  end
end
