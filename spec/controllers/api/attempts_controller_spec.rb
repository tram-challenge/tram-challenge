require 'rails_helper'

RSpec.describe Api::AttemptsController, type: :controller do
  let(:uuid) { SecureRandom.uuid }
  let(:player) { Player.find_or_create_by(icloud_user_id: uuid) }
  let(:in_progress_attempt) {
    player.attempts.create(started_at: Time.now)
  }
  let(:completed_attempt) {
    player.attempts.create(started_at: 3.days.ago, finished_at: 1.day.ago)
  }

  describe "GET index" do
    context "when the player has no attempts" do
      it "renders an empty list of attempts" do
        get :index, params: { icloud_user_id: uuid }

        expect(response.status).to eq(200)

        attempts = JSON.parse(response.body)
        expect(attempts).to eq([])
      end
    end

    context "when the player some attempts" do
      before :each do
        in_progress_attempt
        completed_attempt
      end

      it "renders a list of attempts" do
        get :index, params: { icloud_user_id: uuid }

        expect(response.status).to eq(200)

        attempts = JSON.parse(response.body)
        expect(attempts.size).to eq(2)

        expect(attempts.first.fetch("id")).to eq(in_progress_attempt.id)
      end
    end
  end

  describe "GET show" do
    it "returns the attempt details" do
      get :show, params: { id: in_progress_attempt.id, icloud_user_id: uuid }

      expect(response.status).to eq(200)

      attempt = JSON.parse(response.body)
      expect(attempt.fetch("id")).to eq(in_progress_attempt.id)
      expect(attempt.fetch("started_at")).to_not be_nil
      expect(attempt.fetch("current_time")).to_not be_nil
      expect(attempt.fetch("elapsed_time")).to_not be_nil
    end
  end

  describe "PATCH update" do
    it "marks the attempt as finished" do
      expect(in_progress_attempt.finished_at).to be_nil

      patch :update, params: { id: in_progress_attempt.id, icloud_user_id: uuid }

      expect(in_progress_attempt.reload.finished_at).to_not be_nil
    end

    context "when the nickname parameter is present" do
      it "updates the player's nickname" do
        patch :update, params: {
          id: in_progress_attempt.id,
          icloud_user_id: uuid,
          nickname: "Mistake Not…"
        }

        expect(in_progress_attempt.player.reload.nickname).to eq("Mistake Not…")
      end
    end
  end
end
