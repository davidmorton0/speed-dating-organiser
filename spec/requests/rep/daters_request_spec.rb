# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rep::Daters', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:event) { create(:event, title: 'Dating Event', rep: rep, organisation: rep.organisation) }
  let(:rep) { create(:rep) }

  before { sign_in rep }

  describe '#index' do
    context 'when there are daters for the event' do
      let(:daters) { create_list(:dater, 3, event: event) }

      before { daters }

      it 'shows the page' do
        get rep_event_daters_path(event)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Daters')
        daters.each do |dater|
          expect(response.body).to include(CGI.escapeHTML(dater.name))
          expect(response.body).to include(dater.email)
          expect(response.body).to include(dater.phone_number)
        end
        expect(response.body).to include('Add')
      end
    end

    context 'when there are no daters for the event' do
      it 'shows the page' do
        get rep_event_daters_path(event)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Daters')
        expect(response.body).to include('Add')
      end
    end

    context 'when the rep is signed out' do
      before { sign_out rep }

      it 'redirects to the rep sign in page' do
        get rep_event_daters_path(event)

        expect(response).to redirect_to new_rep_session_path
      end
    end

    context 'when the rep is not assigned to the event' do
      before { sign_in create(:rep) }

      it 'redirects to the rep event page' do
        get rep_event_daters_path(event)

        expect(response).to redirect_to redirect_to rep_events_path
      end
    end
  end

  describe '#show' do
    let(:dater) { create(:dater, event: event, gender: 'female') }

    context 'when there are possible matches for the event' do
      let(:possible_matches) { create_list(:dater, 3, :male, event: event) }
      let(:non_match) { create(:dater, :female, event: event) }

      before do
        possible_matches
        non_match
      end

      it 'shows only the possible matches' do
        get rep_event_dater_path(event, dater)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Matches')
        possible_matches.each do |match|
          expect(response.body).to include(CGI.escapeHTML(match.name))
        end
        expect(response.body).not_to include(CGI.escapeHTML(non_match.name))
        expect(response.body).to include('Update')
      end
    end

    context 'when there are no possible matches for the event' do
      it 'shows the empty page' do
        get rep_event_dater_path(event, dater)

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Matches')
        expect(response.body).to include('Update')
      end
    end

    context 'when the dater is not part of the event' do
      let(:dater) { create(:dater) }

      it 'redirects to the event page' do
        get rep_event_dater_path(event, dater)

        expect(response).to redirect_to rep_event_path(event)
        expect(flash[:alert]).to match(/Dater not part of this event/)
      end
    end

    context 'when the rep is not assigned to the event' do
      before { sign_in create(:rep) }

      it 'redirects to the rep event page' do
        get rep_event_dater_path(event, dater)

        expect(response).to redirect_to redirect_to rep_events_path
      end
    end

    context 'when the rep is signed out' do
      before { sign_out rep }

      it 'redirects to the rep sign in page' do
        get rep_event_daters_path(event)

        expect(response).to redirect_to new_rep_session_path
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

  describe '#update' do
    let(:params) do
      {
        id: dater.id,
        event_id: event.id,
        dater: { matches: new_matches },
      }
    end
    let(:dater) do
      create(:dater, event: event, gender: 'female', matches: matches)
    end
    let(:matches) { [possible_matches[0].id.to_s] }
    let(:possible_matches) { create_list(:dater, 3, :male, event: event) }

    context 'when matches are changed' do
      let(:new_matches) { ['', possible_matches[1].id.to_s, possible_matches[2].id.to_s] }

      it 'updates the dater matches' do
        expect { put rep_event_dater_path(params) }
          .to change { dater.reload.matches }.from(matches).to(new_matches[1..2])
        expect(response).to redirect_to rep_event_matches_path(event)
        expect(flash[:notice]).to match(/Matches updated/)
      end

      context 'when the rep is not assigned to the event' do
        before { sign_in create(:rep) }

        it 'does not change matches and redirects to the rep event page' do
          expect { put rep_event_dater_path(params) }.not_to change { dater.reload.matches }

          expect(response).to redirect_to redirect_to rep_events_path
          expect(flash[:notice]).to be_nil
        end
      end

      context 'when the rep is signed out' do
        before { sign_out rep }

        it 'does not change matches and redirects to the rep sign in page' do
          expect { put rep_event_dater_path(params) }.not_to change { dater.reload.matches }

          expect(response).to redirect_to new_rep_session_path
          expect(flash[:notice]).to be_nil
        end
      end
    end

    context 'when all matches are removed' do
      let(:new_matches) { ['', '', ''] }

      it 'updates the dater matches' do
        expect { put rep_event_dater_path(params) }.to change { dater.reload.matches }.from(matches).to([])
        expect(response).to redirect_to rep_event_matches_path(event)
        expect(flash[:notice]).to match(/Matches updated/)
      end
    end
  end

  describe '#create' do
    let(:params) do
      {
        dater: {
          name: 'Mary Smith',
          email: 'marysmith@example.com',
          phone_number: '123456',
          event_id: event.id,
          gender: 'female',
        },
        event_id: event.id,
      }
    end

    context 'when the params are valid' do
      it 'creates a dater' do
        expect { post rep_event_daters_path(params) }.to change(Dater, :count)

        expect(response).to redirect_to rep_event_daters_path(event)
        expect(flash[:notice]).to match(/Dater added/)
      end
    end

    context 'when the params are invalid' do
      let(:params) do
        {
          dater: {
            name: 'Mary Smith',
            email: '',
            phone_number: '123456',
            event_id: event.id,
            gender: 'female',
          },
          event_id: event.id,
        }
      end

      it 'does not create a dater' do
        expect { post rep_event_daters_path(params) }.not_to change(Dater, :count)

        expect(response).to redirect_to rep_event_daters_path(event)
        expect(flash[:alert]).to match(/Dater not added/)
      end
    end
  end
end
