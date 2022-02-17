# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to have_many(:daters) }
  it { is_expected.to have_many(:speed_dates) }

  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to belong_to(:rep).optional(true) }

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

  describe 'dater methods' do
    let(:male_dater) { build(:dater, gender: 'male') }
    let(:female_dater) { build(:dater, gender: 'female') }

    before do
      subject.daters << male_dater
      subject.daters << female_dater
    end

    describe '#female_daters' do
      it 'returns the female daters from an event' do
        expect(subject.female_daters).to eq [female_dater]
      end
    end

    describe '#male_daters' do
      it 'returns the male daters from an event' do
        expect(subject.male_daters).to eq [male_dater]
      end
    end
  end
end
