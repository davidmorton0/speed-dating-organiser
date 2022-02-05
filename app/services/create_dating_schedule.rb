# frozen_string_literal: true

class CreateDatingSchedule
  def initialize(event:)
    @event = event
  end

  def call
    insert_schedule_breaks
    generate_dates

    @appointments = []

    Array(1..number_of_rounds).each do |round|
      generate_appointments_for_round(round: round)
    end

    SpeedDateAppointment.insert_all(appointments)
    event
  end

  private

  attr_accessor :event, :appointments, :dates

  def female_dater_ids
    @female_dater_ids ||= event.female_daters.map(&:id)
  end

  def male_dater_ids
    @male_dater_ids ||= event.male_daters.map(&:id)
  end

  def generate_dates
    @dates = Array.new(number_of_rounds) { [] }

    number_of_rounds.times do |round_index|
      generate_dates_for_round(round_index: round_index)
    end
  end

  def generate_dates_for_round(round_index:)
    higher_number_of_daters.times do
      @dates[round_index] << { event_id: event.id, round: round_index + 1 }
    end
  end

  def generate_appointments_for_round(round:)
    appointments_params = insert_dates(round_index: round - 1)

    appointments_params.each do |speed_date_params, *dater_ids|
      generate_appointments_for_speed_date(speed_date_params['id'], dater_ids.compact)
    end
  end

  def generate_appointments_for_speed_date(id, dater_ids)
    dater_ids.each do |dater_id|
      @appointments << { speed_date_id: id, dater_id: dater_id }
    end
  end

  def insert_dates(round_index:)
    SpeedDate.insert_all(dates[round_index])
      .zip(female_dater_ids, male_dater_ids.rotate(round_index))
  end

  def higher_number_of_daters
    @higher_number_of_daters ||= [female_dater_ids.size, male_dater_ids.size].max
  end

  def number_of_rounds
    @number_of_rounds ||= [higher_number_of_daters, event.max_rounds].min
  end

  def insert_schedule_breaks
    difference_in_daters = (female_dater_ids.size - male_dater_ids.size).abs
    return if difference_in_daters.zero?

    gap_frequency = higher_number_of_daters.to_f / difference_in_daters

    Array(1..difference_in_daters).each do |n|
      insert_schedule_break((n * gap_frequency).ceil - 1)
    end
  end

  def lower_number_of_dater_ids
    @lower_number_of_dater_ids ||= if female_dater_ids.size > male_dater_ids.size
                                     male_dater_ids
                                   else
                                     female_dater_ids
                                   end
  end

  def insert_schedule_break(position)
    lower_number_of_dater_ids.insert(position, nil)
  end
end
