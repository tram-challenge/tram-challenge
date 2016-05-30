require 'rails_helper'

RSpec.describe Attempt, type: :model do
  it { expect(subject).to belong_to :player }
  it { expect(subject).to have_many :attempt_stops }
  it { expect(subject).to have_many :stops }
  it { expect(subject).to validate_presence_of :player }
end
