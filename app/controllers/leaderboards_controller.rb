class LeaderboardsController < ApplicationController
  def show
    set_tab :leaderboard
    @attempts = Attempt.fully_completed_and_valid
  end
end
