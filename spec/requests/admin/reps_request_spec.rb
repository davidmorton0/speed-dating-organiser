# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Reps', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:admin) }
  let(:rep) { create(:rep, organisation: admin.organisation) }

  before do
    sign_in admin
  end

  describe 'index page' do
    context 'when there is an rep for the same organisation as the admin' do
      before do
        rep
      end

      it 'shows the rep' do
        get admin_reps_path
        expect(response).to be_successful
        expect(response.body).to include('Reps')
        expect(response.body).to include(rep.email)
      end
    end

    context 'when there are no reps' do
      it 'shows an empty list' do
        get admin_reps_path
        expect(response).to be_successful
        expect(response.body).to include('Reps')
        expect(response.body).not_to include(rep.email)
      end
    end

    context 'when there is a rep for another organisation' do
      let(:rep) { create(:rep) }

      before do
        rep
      end

      it 'shows an empty list' do
        get admin_reps_path
        expect(response).to be_successful
        expect(response.body).to include('Reps')
        expect(response.body).not_to include(rep.email)
      end
    end
  end

  describe 'edit rep' do
    context 'when the rep is for the same organisation as the admin' do
      it 'shows the edit event page' do
        get edit_admin_rep_path(rep)
        expect(response).to be_successful
        expect(response.body).to include('Reps')
        expect(response.body).to include(rep.email)
      end
    end

    context 'when the rep is for a different organisation than the admin' do
      let(:rep) { create(:rep) }

      it 'redirects to the reps index' do
        get edit_admin_rep_path(rep)
        expect(response).to redirect_to(admin_reps_path)
      end
    end
  end

  describe 'update rep' do
    let(:params) do
      { id: rep.id,
        rep: { email: 'new_email@example.com' } }
    end

    context 'when the rep is for the same organisation as the admin' do
      it 'updates the rep' do
        expect { patch admin_rep_path(params) }.to change { rep.reload.email }.to('new_email@example.com')
        expect(flash[:success]).to match(/Rep updated/)
      end
    end

    context 'when the rep is for a different organisation than the admin' do
      let(:rep) { create(:rep) }

      let(:params) do
        { id: rep.id,
          rep: { email: 'new_email@example.com' } }
      end

      it 'redirects to the events index' do
        expect { patch admin_rep_path(params) }.not_to change { rep.reload.email }
        expect(response).to redirect_to(admin_reps_path)
        expect(flash[:success]).to be_nil
      end
    end
  end

  describe 'destroy rep' do
    before { rep }

    context 'when the rep is for the same organisation as the admin' do
      it 'deletes the rep' do
        expect { delete admin_rep_path(rep) }.to change(Rep, :count).by(-1)
        expect(flash[:success]).to match(/Rep Deleted/)
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:rep) { create(:rep) }

      it 'does not delete the rep' do
        expect { delete admin_rep_path(rep) }.not_to change(Rep, :count)
        expect(flash[:success]).to be_nil
      end
    end
  end
end
