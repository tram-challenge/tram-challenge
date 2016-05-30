require 'rails_helper'

RSpec.describe Attempt, type: :model do
  it { expect(subject).to belong_to :player }
  it { expect(subject).to have_many :attempt_stops }
  it { expect(subject).to have_many :stops }
  it { expect(subject).to validate_presence_of :player }

  describe "#elapsed_time" do
    context "with pretty: false" do
      it "returns the elapsed time in seconds" do
        attempt = Attempt.new(started_at: 60.seconds.ago)
        expect(attempt.elapsed_time).to be >= 60
        expect(attempt.elapsed_time(pretty: false)).to be >= 60
      end
    end

    context "with pretty: true" do
      it "returns the formatted elapsed time" do
        attempt = Attempt.new(started_at: 30.seconds.ago)
        expect(attempt.elapsed_time(pretty: true)).to match(/00:00:\d{,2}/)

        attempt.started_at = 37.minutes.ago
        expect(attempt.elapsed_time(pretty: true)).to match(/\d{,2}:\d{,2}:\d{,2}/)

        attempt.started_at = 3.days.ago
        expect(attempt.elapsed_time(pretty: true)).to match(/03:\d{,2}:\d{,2}:\d{,2}/)
      end
    end
  end
end
