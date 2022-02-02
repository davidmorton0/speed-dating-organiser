require 'rails_helper'

RSpec.describe Dater, type: :model do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to validate_presence_of(:email) }

  describe '#matches_with' do
    let(:dater1) { create(:dater) }
    let(:dater2) { create(:dater) }

    context 'when daters match each other' do
      before do
        dater1.matches = [dater2.id]
        dater2.matches = [dater1.id]
      end

      it 'returns the correct matches' do
        expect(dater1.matches_with?(dater2)).to eq [true, true]
      end
    end

    context 'when the first dater matches the other' do
      before do
        dater1.matches = [dater2.id]
      end

      it 'returns the correct matches' do
        expect(dater1.matches_with?(dater2)).to eq [true, false]
      end
    end

    context 'when the second dater matches the other' do
      before do
        dater2.matches = [dater1.id]
      end

      it 'returns the correct matches' do
        expect(dater1.matches_with?(dater2)).to eq [false, true]
      end
    end

    context 'when the daters do not match each other' do
      it 'returns the correct matches' do
        expect(dater1.matches_with?(dater2)).to eq [false, false]
      end
    end
  end
end
