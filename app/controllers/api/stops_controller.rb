class Api::StopsController < Api::BaseController
  skip_before_action :require_icloud_user_id

  def index
    expires_in 2.minutes, public: true

    stops = Stop.all
    render json: StopRepresenter.for_collection.new(stops)
  end

  def show
    expires_in 2.minutes, public: true

    stop = Stop.find(params[:id])
    render json: StopRepresenter.new(stop)
  end
end
