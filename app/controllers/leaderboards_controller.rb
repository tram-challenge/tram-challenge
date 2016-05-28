class LeaderboardsController < ApplicationController
  set_tab :leaderboard

  def show
    @attempts = Attempt.fully_completed.order_by_elapsed
  end

  def completion
    @attempts = Attempt.all
  end
end
