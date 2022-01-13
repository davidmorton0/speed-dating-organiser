require 'rails_helper'

RSpec.describe SpeedDate, type: :model do
  it { should belong_to(:dater1) }
  it { should belong_to(:dater2) }
  it { should belong_to(:event) }
  it { is_expected.to validate_presence_of(:round) }
end
