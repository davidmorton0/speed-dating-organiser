# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/it_authenticates_the_admin'

RSpec.describe 'Admin::Events', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:admin) }
  let(:event) { create(:event, title: 'Dating Event', organisation: admin.organisation) }

  before do
    sign_in admin
  end

  describe '#index' do
    subject { get admin_events_path }

    it_behaves_like 'it authenticates the admin'

    context 'when there is an event for the same organisation as the admin' do
      before do
        event
      end

      it 'shows an event' do
        subject

        expect(response).to be_successful
        expect(response.body).to include('Events')
        expect(response.body).to include('Dating Event')
      end
    end

    context 'when there are no events' do
      it 'shows an empty list' do
        subject

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
        subject

        expect(response).to be_successful
        expect(response.body).to include('Events')
        expect(response.body).not_to include('Dating Event')
      end
    end
  end

  describe '#show' do
    subject { get admin_event_path(event) }

    let(:daters) { male_daters + female_daters }
    let(:male_daters) { create_list(:dater, 3, gender: 'male', event: event) }
    let(:female_daters) { create_list(:dater, 4, gender: 'female', event: event) }

    it_behaves_like 'it authenticates the admin'

    context 'when the event is for the same organisation as the admin' do
      before do
        daters
      end

      it 'shows the event' do
        subject

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
        subject

        expect(response).to redirect_to(admin_events_path)
      end
    end
  end

  describe '#new' do
    subject { get new_admin_event_path }

    it_behaves_like 'it authenticates the admin'

    it 'shows an empty list' do
      subject

      expect(response).to be_successful
      expect(response.body).to include('New Event')
    end
  end

  describe '#create' do
    subject { post admin_events_path(params) }

    let(:organisation) { admin.organisation }
    let(:rep) { create(:rep, organisation: organisation) }

    context 'when the event parameters are valid' do
      let(:date) { DateTime.current.beginning_of_hour }
      let(:params) do
        {
          event: {
            title: 'Knitting Event',
            starts_at: date,
            rep_id: rep.id,
            organisation_id: organisation.id,
          },
        }
      end

      it_behaves_like 'it authenticates the admin'

      it 'creates the event' do
        subject

        new_event = Event.last
        expect(new_event).to have_attributes(
          title: 'Knitting Event',
          starts_at: date,
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
            starts_at: Date.current,
            rep_id: rep.id,
            organisation_id: organisation.id,
          },
        }
      end

      it 'does not create an event' do
        expect { subject }.not_to change(Event, :count)
        expect(response).to render_template(:new)
        expect(flash[:error]).to match(/Title/)
      end
    end

    context 'when the assigned rep is from another organisation' do
      let(:params) do
        {
          event: {
            title: 'Knitting Event',
            starts_at: Date.current,
            rep_id: create(:rep).id,
            organisation_id: organisation.id,
          },
        }
      end

      it 'does not create an event' do
        expect { subject }.not_to change(Event, :count)
        expect(response).to render_template(:new)
        expect(flash[:error]).to match(/Rep is not from/)
      end
    end
  end

  describe '#edit' do
    subject { get edit_admin_event_path(event) }

    it_behaves_like 'it authenticates the admin'

    context 'when the event is for the same organisation as the admin' do
      it 'shows the edit event page' do
        subject

        expect(response).to be_successful
        expect(response.body).to include('Dating Event')
        expect(response.body).to include('Edit Event Details')
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'redirects to the events index' do
        subject

        expect(response).to redirect_to(admin_events_path)
      end
    end
  end

  describe '#update' do
    subject { patch admin_event_path(params) }

    context 'when updating the event title' do
      let(:params) do
        { id: event.id,
          event: { title: 'Knitting Event' } }
      end

      it_behaves_like 'it authenticates the admin'

      context 'when the event is for the same organisation as the admin' do
        it 'updates the event title' do
          expect { subject }.to change { event.reload.title }.to('Knitting Event')
          expect(flash[:success]).to match(/Event updated/)
        end
      end

      context 'when the event is for a different organisation than the admin' do
        let(:event) { create(:event, title: 'Dating Event') }

        it 'redirects to the events index' do
          expect { subject }.not_to change { event.reload.title }
          expect(response).to redirect_to(admin_events_path)
          expect(flash[:success]).to be_nil
        end
      end
    end

    context 'when updating the rep for the event' do
      context 'when the assigned rep is for the same organisation as the admin' do
        let(:rep) { create(:rep, organisation: admin.organisation) }

        let(:params) do
          { id: event.id,
            event: { rep_id: rep.id } }
        end

        it 'updates the event rep' do
          expect { subject }.to change { event.reload.rep }.to(rep)
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

        it 'updates the event rep' do
          expect { subject }.to change { event.reload.rep }.to(nil)
          expect(flash[:success]).to match(/Event updated/)
        end
      end

      context 'when the assigned rep is for a different organisation then the admin' do
        let(:rep) { create(:rep, organisation: create(:organisation)) }

        let(:params) do
          { id: event.id,
            event: { rep_id: rep.id } }
        end

        it 'does not update the event rep' do
          expect { subject }.not_to change { event.reload.rep }
          expect(response).not_to be_successful
          expect(flash[:error]).to match(/Rep is not/)
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete admin_event_path(event) }

    before { event }

    it_behaves_like 'it authenticates the admin'

    context 'when the event is for the same organisation as the admin' do
      it 'deletes an event' do
        expect { subject }.to change(Event, :count).by(-1)
        expect(flash[:success]).to match(/Event deleted/)
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:event) { create(:event, title: 'Dating Event') }

      it 'does not delete the event' do
        expect { subject }.not_to change(Event, :count)
        expect(flash[:success]).to be_nil
      end
    end
  end
end
