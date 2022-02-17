# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rep, type: :model do
  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to have_many(:events) }
end
