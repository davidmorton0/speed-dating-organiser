# frozen_string_literal: true

RSpec.shared_examples 'it authenticates the admin' do
  context 'when the admin is logged in' do
    it 'does not redirect to the sign in page' do
      subject

      expect(response).not_to redirect_to new_admin_session_path
    end
  end

  context 'when the admin is logged out' do
    before do
      sign_out admin
    end

    it 'redirects to the sign in page' do
      subject

      expect(response).to redirect_to new_admin_session_path
    end
  end
end
