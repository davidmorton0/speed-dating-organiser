# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateDatingSchedule do
  subject { described_class.new(event: event).call }

  let(:event) { create(:event, max_rounds: max_rounds) }
  let(:max_rounds) { 5 }
  let(:females) { create_list(:dater, number_of_females, :female, event: event) }
  let(:males) { create_list(:dater, number_of_males, :male, event: event) }
  let(:number_of_daters) { number_of_females + number_of_males }
  let(:higher_number_of_daters) { [number_of_females, number_of_males].max }

  before do
    females
    males
  end

  RSpec.shared_examples 'creates the correct schedule' do
    it 'creates the right total number of speed dates and speed date appointments in each round' do
      expect(subject).to eq event

      speed_dates = SpeedDate.all
      expect(speed_dates.size).to eq(rounds * dates_per_round * 2)

      (1..rounds).each do |round|
        speed_dates_for_round = speed_dates.select { |speed_date| speed_date.round == round }
        daters_for_round = speed_dates_for_round.map(&:dater_id)
        datees_for_round = speed_dates_for_round.map(&:datee_id)

        expect(speed_dates_for_round.size).to eq higher_number_of_daters * 2
        expect(daters_for_round.compact.uniq.size).to eq number_of_daters
        expect(datees_for_round.compact.uniq.size).to eq number_of_daters
      end

      speed_dates.each do |speed_date|
        expect(speed_date.dater).not_to eq speed_date.datee
        expect(speed_date.dater.present? || speed_date.datee.present?).to be true
      end
    end
  end

  context 'when there are 5 male and 5 female daters' do
    let(:number_of_females) { 5 }
    let(:number_of_males) { 5 }
    let(:rounds) { 5 }
    let(:dates_per_round) { 5 }

    it_behaves_like 'creates the correct schedule'
  end

  context 'when there are 4 male and 5 female daters' do
    let(:number_of_females) { 5 }
    let(:number_of_males) { 4 }
    let(:rounds) { 5 }
    let(:dates_per_round) { 5 }

    it_behaves_like 'creates the correct schedule'
  end

  context 'when there are 5 male and 4 female daters' do
    let(:number_of_females) { 4 }
    let(:number_of_males) { 5 }
    let(:rounds) { 5 }
    let(:dates_per_round) { 5 }

    it_behaves_like 'creates the correct schedule'
  end

  context 'when there are 3 male and 5 female daters' do
    let(:number_of_females) { 5 }
    let(:number_of_males) { 3 }
    let(:rounds) { 5 }
    let(:dates_per_round) { 5 }

    it_behaves_like 'creates the correct schedule'
  end

  context 'when there are 5 male and 3 female daters' do
    let(:number_of_females) { 3 }
    let(:number_of_males) { 5 }
    let(:rounds) { 5 }
    let(:dates_per_round) { 5 }

    it_behaves_like 'creates the correct schedule'
  end

  context 'when there are no daters' do
    let(:number_of_females) { 0 }
    let(:number_of_males) { 0 }

    it 'does not create any dates' do
      expect { subject }.not_to change(SpeedDate, :count)
    end
  end

  context 'when there is a maximum of 3 rounds' do
    let(:number_of_females) { 5 }
    let(:number_of_males) { 5 }
    let(:rounds) { 3 }
    let(:dates_per_round) { 5 }
    let(:max_rounds) { 3 }

    it_behaves_like 'creates the correct schedule'
  end
end
