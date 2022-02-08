# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dater::SpeedDates', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:event) { create(:event, title: 'Dating Event') }
  let(:male_daters) { create_list(:dater, 3, :male, event: event) }
  let(:female_daters) { create_list(:dater, 2, :female, event: event) }

  describe '#index' do
    before do
      sign_in male_daters.first
    end

    context 'when there is no schedule' do
      it 'shows the event' do
        get dater_event_speed_dates_path(event)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Schedule has not been created yet')
      end
    end

    context 'when there is a schedule' do
      before do
        SpeedDate.create(round: 1, event: event, dater: female_daters[0], datee: male_daters[0])
        SpeedDate.create(round: 1, event: event, dater: female_daters[1], datee: male_daters[1])
        SpeedDate.create(round: 1, event: event, dater: nil, datee: male_daters[2])
        SpeedDate.create(round: 1, event: event, dater: male_daters[0], datee: female_daters[0])
        SpeedDate.create(round: 1, event: event, dater: male_daters[1], datee: female_daters[1])
        SpeedDate.create(round: 1, event: event, dater: male_daters[2], datee: nil)
      end

      it 'shows the event' do
        get dater_event_speed_dates_path(event)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).not_to include('Schedule has not been created yet')
        event.daters.each do |dater|
          expect(response.body).to include(CGI.escapeHTML(dater.name))
        end
      end
    end

  end
end
