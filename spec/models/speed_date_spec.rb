# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpeedDate, type: :model do
  it { is_expected.to belong_to(:dater).optional }
  it { is_expected.to belong_to(:datee).optional }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to validate_presence_of(:round) }
end
