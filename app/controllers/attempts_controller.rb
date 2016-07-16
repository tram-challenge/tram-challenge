class AttemptsController < ApplicationController
  def index
    set_tab :leaderboard
    @attempts = Attempt.fully_completed_and_valid
  end

  def show
    set_tab :leaderboard
    @attempt = Attempt.find(params[:id])
  end
end
