# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/it_authenticates_the_admin'

RSpec.describe 'Admin::Reps', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:admin) }
  let(:rep) { create(:rep, organisation: admin.organisation) }

  before do
    sign_in admin
  end

  describe '#index' do
    subject { get admin_reps_path }

    it_behaves_like 'it authenticates the admin'

    context 'when there is a rep for the same organisation as the admin' do
      before do
        rep
      end

      it 'shows the rep' do
        subject
        expect(response).to be_successful
        expect(response.body).to include('Reps')
        expect(response.body).to include(rep.email)
      end
    end

    context 'when there are no reps' do
      it 'shows an empty list' do
        subject
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
        subject
        expect(response).to be_successful
        expect(response.body).to include('Reps')
        expect(response.body).not_to include(rep.email)
      end
    end
  end

  describe '#edit' do
    subject { get edit_admin_rep_path(rep) }

    it_behaves_like 'it authenticates the admin'

    context 'when the rep is for the same organisation as the admin' do
      it 'shows the edit event page' do
        subject
        expect(response).to be_successful
        expect(response.body).to include('Reps')
        expect(response.body).to include(rep.email)
      end
    end

    context 'when the rep is for a different organisation than the admin' do
      let(:rep) { create(:rep) }

      it 'redirects to the reps index' do
        subject
        expect(response).to redirect_to(admin_reps_path)
      end
    end
  end

  describe '#update' do
    subject { patch admin_rep_path(params) }

    let(:params) do
      { id: rep.id,
        rep: { email: 'new_email@example.com' } }
    end

    it_behaves_like 'it authenticates the admin'

    context 'when the rep is for the same organisation as the admin' do
      it 'updates the rep' do
        expect { subject }.to change { rep.reload.email }.to('new_email@example.com')
        expect(flash[:success]).to match(/Rep updated/)
      end
    end

    context 'when the rep is for a different organisation than the admin' do
      let(:rep) { create(:rep) }

      let(:params) do
        { id: rep.id, rep: { email: 'new_email@example.com' } }
      end

      it 'redirects to the events index' do
        expect { subject }.not_to change { rep.reload.email }
        expect(response).to redirect_to(admin_reps_path)
        expect(flash[:success]).to be_nil
      end
    end
  end

  describe '#create' do
    subject { post admin_reps_path(params) }

    let(:params) do
      { email: 'rep_email@example.com' }
    end

    it_behaves_like 'it authenticates the admin'

    context 'when the email is valid' do
      it 'creates a rep' do
        expect { subject }.to(change(Rep, :count).by(1)
        .and(change(ActionMailer::Base.deliveries, :count).by(1)))

        expect(flash[:success]).to match(/Invitation Email Sent/)
        expect(response).to redirect_to(admin_reps_path)
      end
    end

    context 'when the email is not valid' do
      let(:params) do
        { email: '' }
      end

      it 'raises an exception' do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe '#destroy' do
    subject { delete admin_rep_path(rep) }

    before { rep }

    it_behaves_like 'it authenticates the admin'

    context 'when the rep is for the same organisation as the admin' do
      it 'deletes the rep' do
        expect { subject }.to change(Rep, :count).by(-1)
        expect(flash[:success]).to match(/Rep Deleted/)
      end
    end

    context 'when the event is for a different organisation than the admin' do
      let(:rep) { create(:rep) }

      it 'does not delete the rep' do
        expect { subject }.not_to change(Rep, :count)
        expect(flash[:success]).to be_nil
      end
    end
  end

  describe '#resend_invitation' do
    subject { patch admin_rep_resend_invitation_path(params) }

    let(:params) { { id: rep.id } }

    before { rep }

    it_behaves_like 'it authenticates the admin'

    context 'when the rep is for the same organisation as the admin' do
      it 'resends the invitation' do
        expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(flash[:success]).to match(/Invitation Email Resent/)
        expect(response).to redirect_to(admin_reps_path)
      end
    end

    context 'when the rep is for a different organisation than the admin' do
      let(:params) { { id: create(:rep).id } }

      it 'redirects to the events index' do
        expect { subject }.not_to change { rep.reload.email }
        expect(flash[:success]).to be_nil
      end
    end
  end
end
