# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Daters", type: :request, aggregate_failures: true do
  let(:event) { create(:event, title: 'Dating Event') }

  describe 'show event page' do
    let(:daters) { male_daters + female_daters }
    let(:male_daters) { create_list(:dater, 3, gender: 'male', event: event) }
    let(:female_daters) { create_list(:dater, 4, gender: 'female', event: event) }

    before do
      daters
    end

    it 'shows the daters' do
      get event_daters_path(event)
      expect(response).to be_successful
      expect(response.body).to include('Daters')
      daters.each do |dater|
        expect(response.body).to include(CGI.escapeHTML(dater.name))
      end
      expect(response.body).to include('Add dater')
    end
  end
end