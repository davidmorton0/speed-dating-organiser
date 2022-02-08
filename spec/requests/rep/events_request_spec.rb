# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:rep) { create(:rep) }
  let(:event) { create(:event, title: 'Dating Event', organisation: rep.organisation, rep: rep) }

  before do
    sign_in rep
  end

  describe 'index page' do
    context 'when there is an event for the same organisation as the admin' do
      before do
        event
      end

      it 'shows an event' do
        get rep_events_path
        expect(response).to be_successful
        expect(response.body).to include('Events')
        expect(response.body).to include('Dating Event')
      end
    end

    context 'when there are no events' do
      it 'shows an empty list' do
        get rep_events_path
        expect(response).to be_successful
        expect(response.body).to include('Events')
        expect(response.body).not_to include('Dating Event')
      end
    end

    context 'when there is an event for another rep' do
      let(:event) { create(:event, title: 'Dating Event', organisation: rep.organisation) }

      before do
        event
      end

      it 'shows an empty list' do
        get rep_events_path
        expect(response).to be_successful
        expect(response.body).to include('Events')
        expect(response.body).not_to include('Dating Event')
      end
    end
  end

  describe 'show event page' do
    let(:daters) { male_daters + female_daters }
    let(:male_daters) { create_list(:dater, 3, gender: 'male', event: event) }
    let(:female_daters) { create_list(:dater, 4, gender: 'female', event: event) }

    context 'when the event is assigned to the rep' do
      before do
        daters
      end

      it 'shows the event' do
        get rep_event_path(event)
        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include(daters.count.to_s)
        expect(response.body).to include(male_daters.count.to_s)
        expect(response.body).to include(female_daters.count.to_s)
      end
    end

    context 'when the event is assigned to a different rep' do
      let(:event) { create(:event, title: 'Dating Event', organisation: rep.organisation) }

      it 'redirects to the events index' do
        get rep_event_path(event)
        expect(response).to redirect_to(rep_events_path)
      end
    end
  end
end
