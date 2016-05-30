require 'rails_helper'

RSpec.describe Api::PlayersController, type: :controller do
  let(:uuid) { SecureRandom.uuid }

  describe "GET show" do
    it "returns the current player's information" do
      get :show, params: { icloud_user_id: uuid }
      expect(response.status).to eq(200)

      player = JSON.parse(response.body)
      expect(player.fetch("icloud_user_id")).to eq(uuid)
    end
  end

  describe "PATCH update" do
    it "updates the current players's nickname" do
      nickname = "Robert'); DROP TABLE students;--"

      patch :update, params: {
        icloud_user_id: uuid,
        player: {
          nickname: nickname
        }
      }

      expect(response.status).to eq(200)

      player = JSON.parse(response.body)
      expect(player.fetch("nickname")).to eq(nickname)
    end
  end
end
