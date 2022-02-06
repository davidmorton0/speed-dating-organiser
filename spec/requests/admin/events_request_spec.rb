# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Events', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:admin) }
  let(:event) { create(:event, title: 'Dating Event', organisation: admin.organisation) }

  before do
    sign_in admin
  end

  describe 'index page' do
    context 'when there is an event for the same organisation as the admin' do
      before do
        event
      end

      it 'shows an event' do
        get admin_events_path
        expect(response).to be_successful
        expect(response.body).to include('Events')
        expect(response.body).to include('Dating Event')
      end
    end

    context 'when there are no events' do
      it 'shows an empty list' do
        get admin_events_path
        expect(response).to be_successful
        expect(response.body).to include('Events')
        expect(response.body).not_to include('Dating Event')
      end
    end

    context 'when there is an event for another organisation' do
      let(:event) { create(:event, title: 'Dating Event') }

      before do
        event
      end

      it 'shows an empty list' do
        get admin_events_path
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

    context 'when the event is for the same organisation as the admin' do
      before do
        daters
      end

      it 'shows the event' do
        get admin_event_path(event)
        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include(daters.count.to_s)
        expect(response.body).to include(male_daters.count.to_s)
        expect(response.body).to include(female_daters.count.to_s)
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'redirects to the events index' do
        get admin_event_path(event)
        expect(response).to redirect_to(admin_events_path)
      end
    end
  end

  describe 'add event page' do
    it 'shows an empty list' do
      get new_admin_event_path
      expect(response).to be_successful
      expect(response.body).to include('New Event')
    end
  end

  describe 'create event' do
    let(:organisation) { admin.organisation }
    let(:rep) { create(:rep, organisation: organisation) }

    context 'when the event parameters are valid' do
      let(:date) { DateTime.current.beginning_of_hour }
      let(:params) do
        {
          event: {
            title: 'Knitting Event',
            date: date,
            rep_id: rep.id,
            organisation_id: organisation.id,
          },
        }
      end

      it 'creates the event' do
        post admin_events_path(params)
        new_event = Event.last
        expect(new_event).to have_attributes(
          title: 'Knitting Event',
          date: date,
          rep_id: rep.id,
          organisation_id: organisation.id,
        )
        expect(response).to redirect_to(admin_events_path)
        expect(flash[:success]).to match(/Event created/)
      end
    end

    context 'when the title is missing' do
      let(:params) do
        {
          event: {
            title: nil,
            date: Date.current,
            rep_id: rep.id,
            organisation_id: organisation.id,
          },
        }
      end

      it 'does not create an event' do
        expect { post admin_events_path(params) }.not_to change(Event, :count)
        expect(response).to render_template(:new)
        expect(flash[:error]).to match(/Title/)
      end
    end

    context 'when the assigned rep is from another organisation' do
      let(:params) do
        {
          event: {
            title: 'Knitting Event',
            date: Date.current,
            rep_id: create(:rep).id,
            organisation_id: organisation.id,
          },
        }
      end

      it 'does not create an event' do
        expect { post admin_events_path(params) }.not_to change(Event, :count)
        expect(response).to render_template(:new)
        expect(flash[:error]).to match(/Rep is not from/)
      end
    end
  end

  describe 'edit event' do
    context 'when the event is for the same organisation as the admin' do
      it 'shows the edit event page' do
        get edit_admin_event_path(event)
        expect(response).to be_successful
        expect(response.body).to include('Dating Event')
        expect(response.body).to include('Edit Event Details')
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'redirects to the events index' do
        get edit_admin_event_path(event)
        expect(response).to redirect_to(admin_events_path)
      end
    end
  end

  describe 'update event' do
    let(:params) do
      { id: event.id,
        event: { title: 'Knitting Event' } }
    end

    context 'when the event is for the same organisation as the admin' do
      it 'updates an event' do
        expect { patch admin_event_path(params) }.to change { event.reload.title }.to('Knitting Event')
        expect(flash[:success]).to match(/Event updated/)
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'redirects to the events index' do
        expect { patch admin_event_path(params) }.not_to change { event.reload.title }
        expect(response).to redirect_to(admin_events_path)
        expect(flash[:success]).to be_nil
      end
    end

    context 'when the assigned rep is for the same organisation as the admin' do
      let(:rep) { create(:rep, organisation: admin.organisation) }

      let(:params) do
        { id: event.id,
          event: { rep_id: rep.id } }
      end

      it 'updates an event' do
        expect { patch admin_event_path(params) }.to change { event.reload.rep }.to(rep)
        expect(flash[:success]).to match(/Event updated/)
      end
    end

    context 'when changing the assigned rep to nil' do
      let(:rep) { create(:rep, organisation: admin.organisation) }
      let(:event) { create(:event, title: 'Dating Event', rep: rep, organisation: admin.organisation) }
      let(:params) do
        { id: event.id,
          event: { rep_id: nil } }
      end

      it 'updates an event' do
        expect { patch admin_event_path(params) }.to change { event.reload.rep }.to(nil)
        expect(flash[:success]).to match(/Event updated/)
      end
    end

    context 'when the assigned rep is for a different organisation then the admin' do
      let(:rep) { create(:rep, organisation: create(:organisation)) }

      let(:params) do
        { id: event.id,
          event: { rep_id: rep.id } }
      end

      it 'does not update the event' do
        expect { patch admin_event_path(params) }.not_to change { event.reload.rep }
        expect(response).not_to be_successful
        expect(flash[:error]).to match(/Rep is not/)
      end
    end
  end

  describe 'delete event' do
    before { event }

    context 'when the event is for the same organisation as the admin' do
      it 'deletes an event' do
        expect { delete admin_event_path(event) }.to change(Event, :count).by(-1)
        expect(flash[:success]).to match(/Event deleted/)
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'does not delete the event' do
        expect { delete admin_event_path(event) }.not_to change(Event, :count)
        expect(flash[:success]).to be_nil
      end
    end
  end
end
