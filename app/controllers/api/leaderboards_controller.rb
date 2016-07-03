class Api::LeaderboardsController < Api::BaseController
  skip_before_action :require_icloud_user_id

  def show
    @attempts = Attempt.fully_completed_and_valid
  end
end
