require 'rails_helper'

RSpec.describe Dater, type: :model do
  it { should belong_to(:event) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.to validate_inclusion_of(:gender).in_array(%w[male female]) }

  describe '#matches_with' do
    let(:dater_1) { create(:dater) }
    let(:dater_2) { create(:dater) }

    context 'when daters match each other' do  
      before do
        dater_1.matches = [dater_2.id]
        dater_2.matches = [dater_1.id]
      end

      it 'returns the correct matches' do
        expect(dater_1.matches_with(dater_2)).to eq [true, true]
      end
    end

    context 'when the first dater matches the other' do  
      before do
        dater_1.matches = [dater_2.id]
      end

      it 'returns the correct matches' do
        expect(dater_1.matches_with(dater_2)).to eq [true, false]
      end
    end

    context 'when the first dater matches the other' do  
      before do
        dater_2.matches = [dater_1.id]
      end

      it 'returns the correct matches' do
        expect(dater_1.matches_with(dater_2)).to eq [false, true]
      end
    end

    context 'when the daters do not match each other' do  
      it 'returns the correct matches' do
        expect(dater_1.matches_with(dater_2)).to eq [false, false]
      end
    end
  end
end
