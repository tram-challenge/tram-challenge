require 'rails_helper'

RSpec.describe Player, type: :model do
  it { expect(subject).to have_many :attempts }
  it { expect(subject).to have_many :attempt_stops }
  it { expect(subject).to validate_presence_of :icloud_user_id }
  it { expect(subject).to validate_uniqueness_of :icloud_user_id }
end
