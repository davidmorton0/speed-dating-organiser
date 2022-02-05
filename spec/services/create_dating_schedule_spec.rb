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
      subject
      speed_dates = SpeedDate.all
      speed_date_appointments = SpeedDateAppointment.all

      expect(speed_dates.size).to eq(rounds * dates_per_round)
      expect(speed_date_appointments.size).to eq(rounds * number_of_daters)

      (1..rounds).each do |round|
        speed_dates_for_round = speed_dates.select { |speed_date| speed_date.round == round }
        speed_date_appointments_for_round = speed_dates_for_round.map { |speed_date| speed_date.speed_date_appointments }.flatten
        daters_for_round_from_appointments = speed_date_appointments_for_round.map { |appointment| appointment.dater_id }

        expect(speed_dates_for_round.size).to eq higher_number_of_daters
        expect(speed_date_appointments_for_round.size).to eq number_of_daters
        expect(daters_for_round_from_appointments.uniq.size).to eq number_of_daters
      end

      date_ids = speed_dates.filter_map do |speed_date|
        daters = speed_date.daters.map(&:id).sort
        daters.size == 1 ? false : daters
      end
      expect(date_ids.size).to eq date_ids.uniq.size

      daters_for_each_date = date_ids.map(&:size)
      expect(daters_for_each_date.min).to be >= 1
      expect(daters_for_each_date.max).to eq 2
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

  context 'when there is a maximum of 3 rounds' do
    let(:number_of_females) { 5 }
    let(:number_of_males) { 5 }
    let(:rounds) { 3 }
    let(:dates_per_round) { 5 }
    let(:max_rounds) { 3 }

    it_behaves_like 'creates the correct schedule'
  end
end
