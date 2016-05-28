class Api::AttemptStopsController < Api::BaseController
  def index
    attempt_stops = attempt.attempt_stops
    render json: AttemptStopRepresenter.for_collection.new(attempt_stops)
  end

  def show
    attempt_stop = attempt.attempt_stops.find(params[:id])
    render json: AttemptStopRepresenter.new(attempt_stop)
  end

  def update
    attempt_stop = attempt.attempt_stops.find(params[:id])

    if params[:attempt_stop][:visited_at]
      attempt_stop.visited_at ||= Time.current
    else
      attempt_stop.visited_at = nil
    end

    if attempt_stop.save
      render json: AttemptStopRepresenter.new(attempt_stop)
    else
      error = {
        error: "Couldn't update AttemptStop",
        errors: attempt_stop.errors
      }
      render json: error, status: :bad_request
    end
  end

  private def attempt
    @attempt ||= current_user.attempts.find(params[:attempt_id])
  end
end
