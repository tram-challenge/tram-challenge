class LeaderboardsController < ApplicationController
  def show
    set_tab :leaderboard
    @attempts = Attempt.fully_completed.order_by_elapsed
  end
end
