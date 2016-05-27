require 'rails_helper'

RSpec.describe Stop, type: :model do
  it { expect(subject).to validate_presence_of :longitude }
  it { expect(subject).to validate_presence_of :latitude }
end
