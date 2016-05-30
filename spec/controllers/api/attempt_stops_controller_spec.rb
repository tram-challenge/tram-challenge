require 'rails_helper'

RSpec.describe Api::AttemptStopsController, type: :controller do
  let(:uuid) { SecureRandom.uuid }
  let(:player) { Player.find_or_create_by(icloud_user_id: uuid) }
  let(:stop) {
    Stop.create(
      name: "Fake stop",
      longitude: 0,
      latitude: 0,
      active: true
    )
  }
  let(:in_progress_attempt) {
    stop
    attempt = player.attempts.create(started_at: Time.now)
  }
  let(:attempt_stop) {
    in_progress_attempt.attempt_stops.first
  }

  describe "PATCH update" do
    before :each do
      in_progress_attempt
    end

    context "the stop[visited] parameter is truthy" do
      it "updates the visited_at attribute" do
        expect(attempt_stop.visited_at).to be_nil

        patch :update, params: {
          id: stop.id,
          icloud_user_id: uuid,
          stop: {
            visited: true,
            user_lat: 3.3,
            user_lon: 4.4
          }
        }

        expect(attempt_stop.reload.visited_at).to_not be_nil
        expect(attempt_stop.reload.latitude).to eq(3.3)
        expect(attempt_stop.reload.longitude).to eq(4.4)
      end
    end

    context "the stop[visited] parameter is falsey" do
      it "marks the stop as not visited" do
        attempt_stop.update_attributes(
          visited_at: Time.now,
          latitude: 3.3,
          longitude: 4.4
        )
        expect(attempt_stop.reload.visited_at).to_not be_nil

        patch :update, params: {
          id: stop.id,
          icloud_user_id: uuid,
          stop: {
            visited: nil
          }
        }

        expect(attempt_stop.reload.visited_at).to be_nil
        expect(attempt_stop.reload.latitude).to be_nil
        expect(attempt_stop.reload.longitude).to be_nil
      end
    end
  end
end
