# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateDatingSchedule do
  subject { described_class.new(event: event).call }

  let(:event) { create(:event) }
  let(:number_of_females) { 5 }
  let(:number_of_males) { 5 }
  let(:females) { create_list(:dater, number_of_females, event: event, gender: 'female') }
  let(:males) { create_list(:dater, number_of_males, event: event, gender: 'male') }

  before do
    females
    males
  end

  context 'when there are 5 male and 5 female daters' do
    it 'creates the correct schedule' do
      expect(subject).to eq [
        [[females[0].id, males[0].id], [females[1].id, males[1].id], [females[2].id, males[2].id], [females[3].id, males[3].id], [females[4].id, males[4].id]],
        [[females[1].id, males[0].id], [females[2].id, males[1].id], [females[3].id, males[2].id], [females[4].id, males[3].id], [females[0].id, males[4].id]],
        [[females[2].id, males[0].id], [females[3].id, males[1].id], [females[4].id, males[2].id], [females[0].id, males[3].id], [females[1].id, males[4].id]],
        [[females[3].id, males[0].id], [females[4].id, males[1].id], [females[0].id, males[2].id], [females[1].id, males[3].id], [females[2].id, males[4].id]],
        [[females[4].id, males[0].id], [females[0].id, males[1].id], [females[1].id, males[2].id], [females[2].id, males[3].id], [females[3].id, males[4].id]]
      ]
      expect(SpeedDate.count).to eq 25
    end
  end

  context 'when there are 4 male and 5 female daters' do
    let(:number_of_females) { 5 }
    let(:number_of_males) { 4 }

    it 'creates the correct schedule' do
      expect(subject).to eq [
        [[females[0].id, males[0].id], [females[1].id, males[1].id], [females[2].id, males[2].id], [females[3].id, males[3].id], [females[4].id, nil]],
        [[females[1].id, males[0].id], [females[2].id, males[1].id], [females[3].id, males[2].id], [females[4].id, males[3].id], [females[0].id, nil]],
        [[females[2].id, males[0].id], [females[3].id, males[1].id], [females[4].id, males[2].id], [females[0].id, males[3].id], [females[1].id, nil]],
        [[females[3].id, males[0].id], [females[4].id, males[1].id], [females[0].id, males[2].id], [females[1].id, males[3].id], [females[2].id, nil]],
        [[females[4].id, males[0].id], [females[0].id, males[1].id], [females[1].id, males[2].id], [females[2].id, males[3].id], [females[3].id, nil]]
      ]
      expect(SpeedDate.count).to eq 25
    end
  end

  context 'when there are 5 male and 4 female daters' do
    let(:number_of_females) { 4 }
    let(:number_of_males) { 5 }

    it 'creates the correct schedule' do
      expect(subject).to eq [
        [[females[0].id, males[0].id], [females[1].id, males[1].id], [females[2].id, males[2].id], [females[3].id, males[3].id], [nil, males[4].id]],
        [[females[1].id, males[0].id], [females[2].id, males[1].id], [females[3].id, males[2].id], [nil, males[3].id], [females[0].id, males[4].id]],
        [[females[2].id, males[0].id], [females[3].id, males[1].id], [nil, males[2].id], [females[0].id, males[3].id], [females[1].id, males[4].id]],
        [[females[3].id, males[0].id], [nil, males[1].id], [females[0].id, males[2].id], [females[1].id, males[3].id], [females[2].id, males[4].id]],
        [[nil, males[0].id], [females[0].id, males[1].id], [females[1].id, males[2].id], [females[2].id, males[3].id], [females[3].id, males[4].id]]
      ]
      expect(SpeedDate.count).to eq 25
    end
  end

  context 'when there are 3 male and 5 female daters' do
    let(:number_of_females) { 5 }
    let(:number_of_males) { 3 }

    it 'creates the correct schedule' do
      expect(subject).to eq [
        [[females[0].id, males[0].id], [females[1].id, males[1].id], [females[2].id, nil], [females[3].id, males[2].id], [females[4].id, nil]],
        [[females[1].id, males[0].id], [females[2].id, males[1].id], [females[3].id, nil], [females[4].id, males[2].id], [females[0].id, nil]],
        [[females[2].id, males[0].id], [females[3].id, males[1].id], [females[4].id, nil], [females[0].id, males[2].id], [females[1].id, nil]],
        [[females[3].id, males[0].id], [females[4].id, males[1].id], [females[0].id, nil], [females[1].id, males[2].id], [females[2].id, nil]],
        [[females[4].id, males[0].id], [females[0].id, males[1].id], [females[1].id, nil], [females[2].id, males[2].id], [females[3].id, nil]]
      ]
      expect(SpeedDate.count).to eq 25
    end
  end

  context 'when there are 5 male and 3 female daters' do
    let(:number_of_females) { 3 }
    let(:number_of_males) { 5 }

    it 'creates the correct schedule' do
      expect(subject).to eq [
        [[females[0].id, males[0].id], [females[1].id, males[1].id], [nil, males[2].id], [females[2].id, males[3].id], [nil, males[4].id]],
        [[females[1].id, males[0].id], [nil, males[1].id], [females[2].id, males[2].id], [nil, males[3].id], [females[0].id, males[4].id]],
        [[nil, males[0].id], [females[2].id, males[1].id], [nil, males[2].id], [females[0].id, males[3].id], [females[1].id, males[4].id]],
        [[females[2].id, males[0].id], [nil, males[1].id], [females[0].id, males[2].id], [females[1].id, males[3].id], [nil, males[4].id]],
        [[nil, males[0].id], [females[0].id, males[1].id], [females[1].id, males[2].id], [nil, males[3].id], [females[2].id, males[4].id]]
      ]
      expect(SpeedDate.count).to eq 25
    end
  end
end