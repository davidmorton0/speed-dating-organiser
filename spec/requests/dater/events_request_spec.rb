# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dater::Events', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:event) { create(:event, title: 'Dating Event') }
  let(:dater) { create(:dater, event: event) }

  describe '#show' do
    context 'when the dater is logged in' do
      before do
        sign_in dater
      end

      context 'when the dater belongs to the event' do
        it 'shows the event' do
          get dater_event_path(event)

          expect(response).to be_successful
          expect(response.body).to include(event.title)
        end
      end

      context 'when the dater does not belong to the event' do
        let(:other_event) { create(:event, title: 'Something Else') }

        it 'only shows the daters event' do
          get dater_event_path(other_event)

          expect(response).to be_successful
          expect(response.body).to include(event.title)
          expect(response.body).not_to include(other_event.title)
        end
      end
    end

    context 'when the dater is not logged in' do
      it 'only shows the daters event' do
        get dater_event_path(event)

        expect(response).to redirect_to new_dater_session_path
        expect(response.body).not_to include(event.title)
      end
    end
  end
end
