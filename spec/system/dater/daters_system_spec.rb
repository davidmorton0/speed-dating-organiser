# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dater::Daters', type: :system, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  it 'tests the daters journey'
end
