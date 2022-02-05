require 'rails_helper'

RSpec.describe SpeedDate, type: :model do
  it { is_expected.to have_many(:daters).through(:speed_date_appointments) }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to validate_presence_of(:round) }
end
