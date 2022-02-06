# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dater::Daters', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:event) { create(:event, title: 'Dating Event') }
  let(:dater) do
    create(:dater, event: event, gender: 'female', matches: [male_daters.first.id, male_daters.last.id])
  end
  let(:male_daters) { create_list(:dater, 3, gender: 'male', event: event) }

  describe '#show' do
    before do
      sign_in dater
      male_daters
    end

    it 'shows the daters' do
      get dater_event_dater_path(event, dater)
      expect(response).to be_successful
      expect(response.body).to include('Matches')
      male_daters.each do |match|
        expect(response.body).to include(CGI.escapeHTML(match.name))
      end
      expect(response.body).to include('Update')
    end
  end

  describe '#update' do

    let(:params) do
      {
        id: dater.id,
        event_id: event.id,
        dater: { matches: [''] }
      }
    end

    before do
      sign_in dater
      male_daters
    end

    it 'shows the daters' do
      put dater_event_dater_path(params)
      expect(response).to redirect_to dater_event_path(event)
    end
  end
end