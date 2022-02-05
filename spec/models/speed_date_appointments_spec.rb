require 'rails_helper'

RSpec.describe SpeedDateAppointment, type: :model do
  it { is_expected.to belong_to(:dater) }
  it { is_expected.to belong_to(:speed_date) }
end
