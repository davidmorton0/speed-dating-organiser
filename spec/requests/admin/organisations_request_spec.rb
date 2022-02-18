# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Organisations', type: :request, aggregate_failures: true do
  include Devise::Test::IntegrationHelpers

  let(:organisation) { create(:organisation) }
  let(:admin) { create(:admin, organisation: organisation) }
  let(:rep) { create(:rep, organisation: organisation) }
  let(:event) { create(:event, title: 'Dating Event', organisation: organisation) }
  let(:dater) { create(:dater, event: event) }
  let(:datee) { create(:dater, event: event) }
  let(:speed_date) { create(:speed_date, dater: dater, datee: datee, event: event) }

  describe '#index' do
    subject { delete admin_organisation_path(organisation) }

    before do
      speed_date
      rep
      sign_in admin
    end

    context 'when there is no schedule' do
      it 'deletes all records from the organisation' do
        expect { subject }.to change(Organisation, :count).from(1).to(0)
          .and(change(Admin, :count).from(1).to(0))
          .and(change(Rep, :count).from(1).to(0))
          .and(change(Event, :count).from(1).to(0))
          .and(change(Dater, :count).from(2).to(0))
          .and(change(SpeedDate, :count).from(1).to(0))
      end
    end
  end
end
