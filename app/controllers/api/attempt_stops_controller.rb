class Api::AttemptStopsController < Api::BaseController
  def update
    in_progress = if (attempt = current_player.attempts.in_progress.first)
      attempt
    else
      current_player.attempts.order(created_at: :desc).first!
    end

    attempt_stop = in_progress.attempt_stops.find_by!(stop_id: params[:id])

    if params[:stop][:visited].present? && params[:stop][:visited] != "false"
      attempt_stop.visited_at ||= Time.current
      attempt_stop.longitude ||= params[:stop][:user_lon]
      attempt_stop.latitude ||= params[:stop][:user_lat]
    else
      attempt_stop.visited_at = nil
      attempt_stop.longitude = nil
      attempt_stop.latitude = nil
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
end
