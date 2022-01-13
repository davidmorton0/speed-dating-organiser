require 'rails_helper'

RSpec.describe SpeedDate, type: :model do
  it { should belong_to(:dater_1) }
  it { should belong_to(:dater_2) }
  it { should belong_to(:event) }
  it { is_expected.to validate_presence_of(:round) }
end
