# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dater, type: :model do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to have_many(:speed_dates) }

  it { is_expected.to validate_presence_of(:email) }

  describe '#female?' do
    subject { described_class.new(gender: gender).female? }

    context 'when gender is female' do
      let(:gender) { 'female' }

      it { is_expected.to be true }
    end

    context 'when gender is male' do
      let(:gender) { 'male' }

      it { is_expected.to be false }
    end
  end

  describe '#male?' do
    subject { described_class.new(gender: gender).male? }

    context 'when gender is male' do
      let(:gender) { 'male' }

      it { is_expected.to be true }
    end

    context 'when gender is female' do
      let(:gender) { 'female' }

      it { is_expected.to be false }
    end
  end

  describe '#matches_with' do
    let(:dater1) { build(:dater, id: dater1_id, matches: dater1_matches) }
    let(:dater2) { build(:dater, id: dater2_id, matches: dater2_matches) }
    let(:dater1_id) { -1 }
    let(:dater2_id) { -2 }

    context 'when the first dater matches the second' do
      let(:dater1_matches) { [dater2_id] }

      context 'when the second dater matches the first' do
        let(:dater2_matches) { [dater1_id] }

        it 'returns the correct matches' do
          expect(dater1.matches_with?(dater2)).to eq [true, true]
        end
      end

      context 'when the second dater has no matches' do
        let(:dater2_matches) { [] }

        it 'returns the correct matches' do
          expect(dater1.matches_with?(dater2)).to eq [true, false]
        end
      end
    end

    context 'when the first dater has no matches' do
      let(:dater1_matches) { [] }

      context 'when the second dater matches the first' do
        let(:dater2_matches) { [dater1_id] }

        it 'returns the correct matches' do
          expect(dater1.matches_with?(dater2)).to eq [false, true]
        end
      end

      context 'when the second dater has no matches' do
        let(:dater2_matches) { [] }

        it 'returns the correct matches' do
          expect(dater1.matches_with?(dater2)).to eq [false, false]
        end
      end
    end

    context 'when the first dater has other matches' do
      let(:dater1_matches) { [build(:dater).id] }

      context 'when the second dater matches the first' do
        let(:dater2_matches) { [dater1_id] }

        it 'returns the correct matches' do
          expect(dater1.matches_with?(dater2)).to eq [false, true]
        end
      end

      context 'when the second dater has other matches' do
        let(:dater2_matches) { [build(:dater).id] }

        it 'returns the correct matches' do
          expect(dater1.matches_with?(dater2)).to eq [false, false]
        end
      end
    end
  end
end
