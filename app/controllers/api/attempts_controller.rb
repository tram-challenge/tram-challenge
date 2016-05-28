class Api::AttemptsController < Api::BaseController
  def index
    attempts = current_user.attempts
    render json: AttemptRepresenter.for_collection.new(attempts)
  end

  def show
    attempt = current_user.attempts.find(params[:id])
    render json: AttemptRepresenter.new(attempt)
  end

  def create
    if current_user.attempts.in_progress.any?
      error = {
        error: "One player can only have one active attempt at a time"
      }
      render json: error
    else
      attempt = current_user.attempts.create(started_at: Time.current)
      render json: AttemptRepresenter.new(attempt)
    end
  end

  def update
    attempt = current_user.attempts.in_progress.find(params[:id])
    if attempt.finished_at.nil?
      attempt.update_attributes(finished_at: Time.current)
    end
    render json: AttemptRepresenter.new(attempt)
  end
end
