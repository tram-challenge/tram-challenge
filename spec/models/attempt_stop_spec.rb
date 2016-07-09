require 'rails_helper'

RSpec.describe AttemptStop, type: :model do
  it { expect(subject).to belong_to :attempt }
  it { expect(subject).to belong_to :stop }
  
  describe "#elapsed_time" do
    it "returns the elapsed time in h:m:s" do
      stop = Stop.create(longitude: 60.1, latitude: 24.4, active: true)
      player = Player.create(icloud_user_id: SecureRandom.hex(13))
      attempt = player.attempts.create(started_at: 60.seconds.ago)
      attempt_stop = attempt.attempt_stops[0]
      attempt_stop.visited_at = 30.seconds.ago
      expect(attempt_stop.elapsed_time).to match(/00:00:\d{,2}/)
    end
  end
end
