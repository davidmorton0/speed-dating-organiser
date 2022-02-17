# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rep::SpeedDates', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:rep) { create(:rep) }
  let(:event) { create(:event, title: 'Dating Event', organisation: rep.organisation, rep: rep) }
  let(:male_daters) { create_list(:dater, 3, :male, event: event) }
  let(:female_daters) { create_list(:dater, 2, :female, event: event) }

  describe '#index' do
    before do
      sign_in rep
    end

    context 'when there is no schedule' do
      it 'shows the event' do
        get rep_event_speed_dates_path(event)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Schedule has not been created')
        expect(response.body).to include('Create Schedule')
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
        get rep_event_speed_dates_path(event)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).not_to include('Schedule has not been created yet')
        expect(response.body).to include('Regenerate Schedule')
        event.daters.each do |dater|
          expect(response.body).to include(CGI.escapeHTML(dater.name))
        end
      end
    end

    context 'when the event is assigned to a different rep' do
      let(:event) { create(:event, title: 'Dating Event', organisation: rep.organisation) }

      it 'redirects to the events index' do
        get rep_event_path(event)
        expect(response).to redirect_to(rep_events_path)
      end
    end

    context 'when the rep is signed out' do
      before { sign_out rep }

      it 'redirects to the rep sign in page' do
        get rep_event_matches_path(event)

        expect(response).to redirect_to new_rep_session_path
      end
    end
  end

  describe '#create' do
    let(:dummy_schedule_service) { instance_double(CreateDatingSchedule) }

    before do
      sign_in rep
    end

    context 'when the event is assigned to a the rep' do
      context 'when there are no existing dates' do
        it 'calls the speed date unit' do
          expect(CreateDatingSchedule).to receive(:new).and_return(dummy_schedule_service)
          expect(dummy_schedule_service).to receive(:call)

          post rep_event_speed_dates_path({ event_id: event.id })
          expect(response).to redirect_to(rep_event_speed_dates_path(event))
        end
      end

      context 'when there are existing dates' do
        let(:speed_dates) { create_list(:speed_date, 2, event: event) }

        before { speed_dates }

        it 'destroys any existing dates' do
          expect { post rep_event_speed_dates_path({ event_id: event.id }) }.to change(SpeedDate, :count).by(-2)
        end
      end
    end

    context 'when the event is assigned to a different rep' do
      let(:event) { create(:event, title: 'Dating Event', organisation: rep.organisation) }

      it 'redirects to the events index' do
        get rep_event_path(event)
        expect(response).to redirect_to(rep_events_path)
      end
    end

    context 'when the rep is signed out' do
      before { sign_out rep }

      it 'redirects to the rep sign in page' do
        get rep_event_matches_path(event)

        expect(response).to redirect_to new_rep_session_path
      end
    end
  end
end
