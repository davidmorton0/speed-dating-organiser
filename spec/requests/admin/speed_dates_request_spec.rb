# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::SpeedDates', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:admin) }
  let(:event) { create(:event, title: 'Dating Event', organisation: admin.organisation) }
  let(:male_daters) { create_list(:dater, 3, :male, event: event) }
  let(:female_daters) { create_list(:dater, 2, :female, event: event) }

  describe '#index' do
    subject { get admin_event_speed_dates_path(event) }

    before do
      sign_in admin
    end

    context 'when there is no schedule' do
      it 'shows the event' do
        subject

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
        subject

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).not_to include('Schedule has not been created yet')
        expect(response.body).to include('Regenerate Schedule')
        event.daters.each do |dater|
          expect(response.body).to include(CGI.escapeHTML(dater.name))
        end
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'redirects to the events index' do
        subject

        expect(response).to redirect_to(admin_events_path)
      end
    end

    context 'when the admin is signed out' do
      before { sign_out admin }

      it 'redirects to the admin sign in page' do
        subject

        expect(response).to redirect_to new_admin_session_path
      end
    end
  end

  describe '#create' do
    subject { post admin_event_speed_dates_path({ event_id: event.id }) }

    let(:dummy_schedule_service) { instance_double(CreateDatingSchedule) }

    before do
      sign_in admin
    end

    context 'when the event is the same organisation as the admin' do
      context 'when there are no existing dates' do
        it 'calls the speed date unit' do
          expect(CreateDatingSchedule).to receive(:new).and_return(dummy_schedule_service)
          expect(dummy_schedule_service).to receive(:call)

          subject
          expect(response).to redirect_to(admin_event_speed_dates_path(event))
        end
      end

      context 'when there are existing dates' do
        let(:speed_dates) { create_list(:speed_date, 2, event: event) }

        before { speed_dates }

        it 'destroys any existing dates' do
          expect { subject }.to change(SpeedDate, :count).by(-2)
        end
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'redirects to the events index' do
        subject
        expect(response).to redirect_to(admin_events_path)
      end
    end

    context 'when the admin is signed out' do
      before { sign_out admin }

      it 'redirects to the admin sign in page' do
        subject

        expect(response).to redirect_to new_admin_session_path
      end
    end
  end
end
