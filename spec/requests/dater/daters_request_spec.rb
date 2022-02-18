# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dater::Daters', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:event) { create(:event, title: 'Dating Event') }
  let(:dater) do
    create(:dater, event: event, gender: 'female', matches: matches)
  end
  let(:matches) { [possible_matches[0].id.to_s] }
  let(:possible_matches) { create_list(:dater, 3, :male, event: event) }

  before do
    sign_in dater
  end

  describe '#show' do
    it 'shows the daters' do
      get dater_event_dater_path(event, dater)
      expect(response).to be_successful
      expect(response.body).to include('Matches')
      possible_matches.each do |match|
        expect(response.body).to include(CGI.escapeHTML(match.first_name))
      end
      expect(response.body).to include('Update')
    end
  end

  describe '#update' do
    let(:params) do
      {
        id: dater.id,
        event_id: event.id,
        dater: { matches: new_matches },
      }
    end

    context 'when matches are changed' do
      let(:new_matches) { ['', possible_matches[1].id.to_s, possible_matches[2].id.to_s] }

      it 'updates the dater matches' do
        expect { put dater_event_dater_path(params) }
          .to change { dater.reload.matches }.from(matches).to(new_matches[1..2])
        expect(response).to redirect_to dater_event_path(event)
      end
    end

    context 'when all matches are removed' do
      let(:new_matches) { ['', '', ''] }

      it 'updates the dater matches' do
        expect { put dater_event_dater_path(params) }.to change { dater.reload.matches }.from(matches).to([])
        expect(response).to redirect_to dater_event_path(event)
      end
    end
  end
end
