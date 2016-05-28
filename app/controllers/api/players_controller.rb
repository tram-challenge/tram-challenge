class Api::PlayersController < Api::BaseController
  def show
    render json: PlayerRepresenter.new(current_player)
  end

  def update
    player = current_player
    player.update_attributes(player_params)
    render json: PlayerRepresenter.new(current_player)
  end

  private def player_params
    params.require(:player).permit(:nickname)
  end
end
