require 'rails_helper'

RSpec.describe Api::LeaderboardsController, type: :controller do
  render_views

  let(:attempts) {
    3.times.map do |i|
      player = Player.find_or_create_by(
        nickname: "Player ##{i}",
        icloud_user_id: SecureRandom.uuid
      )
      player.attempts.create(started_at: ((i+1)*5).hours.ago, finished_at: (i+1).hours.ago)
    end
  }

  describe "GET show" do

    it "renders an empty list of attempts" do
      attempts

      get :show
      expect(response.status).to eq(200)

      attempts = JSON.parse(response.body)
      expect(attempts.map {|a| a.fetch("position") }).to eq([1, 2, 3])

      expect(attempts.map {|a| a.fetch("name") }).to eq(["Player #0", "Player #1", "Player #2"])
    end

  end
end
