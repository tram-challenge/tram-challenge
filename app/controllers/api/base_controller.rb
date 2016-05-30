class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  before_action :set_default_response_format
  before_action :require_icloud_user_id

  private def set_default_response_format
    request.format = :json
  end

  private def current_player
    @current_player ||= Player.find_or_create_by(icloud_user_id: params[:icloud_user_id])
  end

  private def require_icloud_user_id
    unless params[:icloud_user_id]
      render json: { error: "The 'icloud_user_id' parameter is missing" }, status: :unauthorized
    end
  end
end
