require 'rails_helper'

RSpec.describe AttemptStop, type: :model do
  it { expect(subject).to belong_to :attempt }
  it { expect(subject).to belong_to :stop }
end
