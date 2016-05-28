require 'rails_helper'

RSpec.describe Attempt, type: :model do
  it { expect(subject).to validate_presence_of :player }
end
