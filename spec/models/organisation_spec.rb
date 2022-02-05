# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organisation, type: :model do
  it { is_expected.to have_many(:admins) }
  it { is_expected.to have_many(:reps) }
  it { is_expected.to have_many(:events) }
end
