class Api::StopsController < Api::BaseController
  skip_before_action :require_icloud_user_id

  def index
    stops = Stop.all
    render json: StopRepresenter.for_collection.new(stops)
  end

  def show
    stop = Stop.find(params[:id])
    render json: StopRepresenter.new(stop)
  end
end