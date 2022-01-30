# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should have_many(:daters) }
  it { should have_many(:speed_dates) }

  it { should belong_to(:organisation) }
  it { should belong_to(:rep).optional(true) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:date) }

  context 'when validating the rep organisation' do
    let(:rep) { build(:rep) }

    context 'when rep belongs to organisation' do
      it 'is valid' do
        subject.rep = rep
        subject.organisation = rep.organisation
        subject.valid?
        expect(subject.errors.full_messages).not_to include('Rep does not belong to this organisation')
      end
    end

    context 'when rep does not belong to organisation' do
      it 'is not valid' do
        subject.rep = rep
        subject.organisation = build(:organisation)
        subject.valid?
        expect(subject.errors.full_messages).to include('Rep does not belong to this organisation')
      end
    end
  end
end
