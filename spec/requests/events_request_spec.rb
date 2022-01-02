# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Events", type: :request, aggregate_failures: true do
  let(:event) { create(:event, title: 'Dating Event') }

  describe 'index page' do
    context 'when there are no events' do
      it 'shows an empty list' do
        get events_path
        expect(response).to be_successful
        expect(response.body).to include('All Events')
        expect(response.body).not_to include('Dating Event')
      end
    end

    context 'when there is an event' do
      before do
        event
      end

      it 'shows an event' do
        get events_path
        expect(response).to be_successful
        expect(response.body).to include('All Events')
        expect(response.body).to include('Dating Event')
      end
    end
  end

  describe 'add event page' do
    it 'shows an empty list' do
      get new_event_path
      expect(response).to be_successful
      expect(response.body).to include('Add Event')
    end
  end

  describe 'create event' do
    let(:params) do
      {
        event: {
          title: 'Knitting Event',
          date: DateTime.current
        }
      }
    end

    it 'shows an empty list' do
      post events_path(params)
      expect(Event.last.title).to eq 'Knitting Event'
    end
  end

  describe 'update event page' do
    it 'shows the update event page' do
      get edit_event_path(event)
      expect(response).to be_successful
      expect(response.body).to include('Update Event')
      expect(response.body).to include('Dating Event')
    end
  end

  describe 'edit event' do
    let(:params) do
      {
        id: event.id,
        event: { title: 'Knitting Event' }
      }
    end

    it 'updates an event' do
      patch event_path(params)
      expect(Event.last.title).to eq 'Knitting Event'
    end
  end

  describe 'delete event' do
    it 'deletes an event' do
      delete event_path(event)
      expect(Event.count).to eq 0
    end
  end
end