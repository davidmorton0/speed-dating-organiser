# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/it_authenticates_the_admin'

RSpec.describe 'Admin::Daters', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:event) { create(:event, title: 'Dating Event') }
  let(:admin) { create(:admin, organisation: event.organisation) }

  before { sign_in admin }

  describe '#index' do
    subject { get admin_event_daters_path(event) }

    context 'when there are daters for the event' do
      let(:daters) { create_list(:dater, 3, event: event) }

      before { daters }

      it 'shows the page' do
        subject

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
        subject

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Daters')
        expect(response.body).to include('Add')
      end
    end
  end

  describe '#show' do
    subject { get admin_event_dater_path(event, dater) }

    let(:dater) { create(:dater, event: event, gender: 'female') }

    context 'when there are possible matches for the event' do
      let(:possible_matches) { create_list(:dater, 3, :male, event: event) }
      let(:non_match) { create(:dater, :female, event: event) }

      before do
        possible_matches
        non_match
      end

      it 'shows only the possible matches' do
        subject

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
        subject

        expect(response).to be_successful
        expect(response.body).to include(event.title)
        expect(response.body).to include('Matches')
        expect(response.body).to include('Update')
      end
    end

    context 'when the admin is not in the same organisation as the event' do
      before { sign_in create(:admin) }

      it 'redirects to the admin event page' do
        subject

        expect(response).to redirect_to redirect_to admin_events_path
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

  describe '#update' do
    subject { put admin_event_dater_path(params) }

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

      context 'when new matches are provided' do
        it 'updates the dater matches' do
          expect { subject }
            .to change { dater.reload.matches }.from(matches).to(new_matches[1..2])
          expect(response).to redirect_to admin_event_matches_path(event)
          expect(flash[:notice]).to match(/Matches updated/)
        end
      end

      context 'when the admin is not part of the same organisation as the event' do
        let(:admin) { create(:admin) }

        it 'does not change matches and redirects to the admin event page' do
          expect { subject }.not_to change { dater.reload.matches }

          expect(response).to redirect_to redirect_to admin_events_path
          expect(flash[:notice]).to be_nil
        end
      end

      context 'when the admin is signed out' do
        before { sign_out admin }

        it 'does not change matches and redirects to the admin sign in page' do
          expect { subject }.not_to change { dater.reload.matches }

          expect(response).to redirect_to new_admin_session_path
          expect(flash[:notice]).to be_nil
        end
      end
    end

    context 'when all matches are removed' do
      let(:new_matches) { [] }

      it 'updates the dater matches' do
        expect { subject }.to change { dater.reload.matches }.from(matches).to([])
        expect(response).to redirect_to admin_event_matches_path(event)
        expect(flash[:notice]).to match(/Matches updated/)
      end
    end
  end

  describe '#create' do
    subject { post admin_event_daters_path(params) }

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
        expect { subject }.to change(Dater, :count)

        expect(response).to redirect_to admin_event_daters_path(event)
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
        expect { subject }.not_to change(Dater, :count)

        expect(response).to redirect_to admin_event_daters_path(event)
        expect(flash[:alert]).to match(/Dater not added: Email can't be blank/)
      end
    end
  end

  describe '#destroy' do
    subject { delete admin_event_dater_path(event, dater) }

    let(:dater) { create(:dater, event: event) }

    before { dater }

    it_behaves_like 'it authenticates the admin'

    context 'when the dater is for the same organisation as the admin' do
      it 'deletes the dater' do
        expect { subject }.to change(Dater, :count).by(-1)
        expect(flash[:success]).to match(/Dater Deleted/)
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:dater) { create(:dater) }

      it 'does not delete the dater' do
        expect { subject }.not_to change(Dater, :count)
        expect(flash[:success]).to be_nil
      end
    end
  end
end
