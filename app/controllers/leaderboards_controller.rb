class LeaderboardsController < ApplicationController
  def show
    set_tab :leaderboard
    @attempts = Attempt.fully_completed_and_valid
  end
  
  
  def show_attempt
    set_tab :leaderboard
    @attempt = Attempt.find_by_id(params[:attempt])
    redirect_to action: :show unless @attempt
  end
end
