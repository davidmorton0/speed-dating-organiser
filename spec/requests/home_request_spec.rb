# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    context 'when logged in as an admin' do
      before { sign_in build(:admin) }

      it 'redirects to the admin events page' do
        get root_path
        expect(response).to redirect_to admin_events_path
      end
    end

    context 'when logged in as a rep' do
      before { sign_in build(:rep) }

      it 'redirects to the rep events page' do
        get root_path
        expect(response).to redirect_to rep_events_path
      end
    end

    context 'when logged in as a dater' do
      let(:dater) { create(:dater) }

      before { sign_in dater }

      it 'redirects to the dater events page' do
        get root_path
        expect(response).to redirect_to dater_event_path(dater.event)
      end
    end

    context 'when not logged in' do
      it 'shows the index page' do
        get root_path
        expect(response).to be_successful
        expect(response.body).to include('Log In')
      end
    end
  end

  describe '#logout' do
    let(:admin) { build(:admin) }

    before do
      sign_in admin
      get root_path
    end

    it 'logs out' do
      expect { get logout_path }.to change { controller.current_admin }.from(admin).to(nil)
      expect(response).to redirect_to root_path
    end
  end

  describe '#login' do
    context 'when logging in as an admin' do
      let(:params) do
        {
          resource: 'admin',
          admin: admin.email,
        }
      end
      let(:admin) { create(:admin) }

      context 'when not logged in' do
        it 'logs in' do
          post login_path(params)

          expect(response).to redirect_to admin_events_path
          expect(controller.current_admin).to eq admin
        end
      end

      context 'when already logged in' do
        let(:logged_in_admin) { create(:admin) }

        before { sign_in logged_in_admin }

        it 'logs in' do
          post login_path(params)

          expect(response).to redirect_to admin_events_path
          expect(controller.current_admin).to eq admin
        end
      end
    end

    context 'when logging in as a rep' do
      let(:params) do
        {
          resource: 'rep',
          rep: rep.email,
        }
      end
      let(:rep) { create(:rep) }

      it 'logs in' do
        post login_path(params)

        expect(response).to redirect_to rep_events_path
        expect(controller.current_rep).to eq rep
      end
    end
  end

  context 'when logging in as a dater' do
    let(:params) do
      {
        resource: 'dater',
        dater: dater.email,
      }
    end
    let(:dater) { create(:dater) }

    it 'logs in' do
      post login_path(params)

      expect(response).to redirect_to dater_event_path(dater.event)
      expect(controller.current_dater).to eq dater
    end
  end
end
