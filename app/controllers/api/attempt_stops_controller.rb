class Api::AttemptStopsController < Api::BaseController
  def update
    attempt_stop = attempt.attempt_stops.find(stop_id: params[:id])

    if params[:stop][:visited]
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
    @attempt ||= current_player.attempts.find(params[:attempt_id])
  end
end
