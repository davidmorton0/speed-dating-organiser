# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dater::Daters', type: :system, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  before do
    driven_by(:selenium_chrome_headless)
  end

  it "enables me to create widgets" do
    visit "/dater/matches"

    fill_in "Name", :with => "My Widget"
    click_button "Create Widget"

    expect(page).to have_text("Widget was successfully created.")
  end
end