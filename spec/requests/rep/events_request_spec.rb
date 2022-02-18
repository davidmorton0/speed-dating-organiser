# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rep::Events', type: :request, aggregate_failures: true do
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

  describe '#matches' do
    context 'when there are daters for the event' do
      let(:daters) { male_daters + female_daters }

      before { daters }

      context 'when there are no matches' do
        let(:female_daters) { create_list(:dater, 2, :female, event: event) }
        let(:male_daters) { create_list(:dater, 2, :male, event: event) }

        it 'shows the matches page with all the daters and no matches' do
          get rep_event_matches_path(event)

          expect(response).to be_successful
          expect(response.body).to include(event.title)
          expect(response.body).to include('Matches')
          daters.each do |dater|
            expect(response.body).to include(CGI.escapeHTML(dater.name))
          end
          expect(response.body).to include('no-no')
          expect(response.body).not_to include('yes-no')
          expect(response.body).not_to include('no-yes')
          expect(response.body).not_to include('yes-yes')
        end
      end

      context 'when there are matches' do
        let(:female_daters) do
          [
            create(:dater, :female, event: event, matches: [male_daters[0].id, male_daters[1].id]),
            create(:dater, :female, event: event, matches: []),
          ]
        end
        let(:male_daters) { create_list(:dater, 2, :male, event: event) }

        before { male_daters[0].update(matches: [female_daters[0].id, female_daters[1].id]) }

        it 'shows the matches page with all the daters and matches' do
          get rep_event_matches_path(event)

          expect(response).to be_successful
          expect(response.body).to include(event.title)
          expect(response.body).to include('Matches')
          daters.each do |dater|
            expect(response.body).to include(CGI.escapeHTML(dater.name))
          end
          expect(response.body).to include('no-no')
          expect(response.body).to include('yes-no')
          expect(response.body).to include('no-yes')
          expect(response.body).to include('yes-yes')
        end
      end
    end

    context 'when there are no daters for the event' do
      it 'shows the matches page' do
        get rep_event_matches_path(event)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Matches')
      end
    end

    context 'when the rep is not assigned to the event' do
      before { sign_in create(:rep) }

      it 'redirects to the rep event page' do
        get rep_event_matches_path(event)

        expect(response).to redirect_to redirect_to rep_events_path
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
