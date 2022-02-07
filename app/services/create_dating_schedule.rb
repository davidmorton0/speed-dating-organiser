# frozen_string_literal: true

class CreateDatingSchedule
  def initialize(event:)
    @event = event
  end

  def call
    insert_schedule_breaks
    generate_dates
    SpeedDate.insert_all(dates)
    event
  end

  private

  attr_accessor :event, :appointments, :dates

  def insert_schedule_breaks
    difference_in_daters = (female_dater_ids.size - male_dater_ids.size).abs
    return if difference_in_daters.zero?

    gap_frequency = higher_number_of_daters.to_f / difference_in_daters

    (1..difference_in_daters).each do |n|
      insert_schedule_break((n * gap_frequency).ceil - 1)
    end
  end

  def insert_schedule_break(position)
    lower_number_of_dater_ids.insert(position, nil)
  end

  def female_dater_ids
    @female_dater_ids ||= event.female_daters.sort_by(&:name).map(&:id)
  end

  def male_dater_ids
    @male_dater_ids ||= event.male_daters.sort_by(&:name).map(&:id)
  end

  def higher_number_of_daters
    @higher_number_of_daters ||= [female_dater_ids.size, male_dater_ids.size].max
  end

  def lower_number_of_dater_ids
    @lower_number_of_dater_ids ||= if female_dater_ids.size > male_dater_ids.size
                                     male_dater_ids
                                   else
                                     female_dater_ids
                                   end
  end

  def generate_dates
    @dates = []

    number_of_rounds.times do |round_index|
      generate_dates_for_round(round_index: round_index)
    end
  end

  def generate_dates_for_round(round_index:)
    male_ids = male_dater_ids.rotate(-round_index)

    higher_number_of_daters.times do |n|
      generate_date(round: round_index + 1, dater_ids: [female_dater_ids[n], male_ids[n]])
    end
  end

  def generate_date(round:, dater_ids:)
    @dates << { event_id: event.id, round: round, dater_id: dater_ids[0], datee_id: dater_ids[1] }
    @dates << { event_id: event.id, round: round, dater_id: dater_ids[1], datee_id: dater_ids[0] }
  end

  def number_of_rounds
    @number_of_rounds ||= [higher_number_of_daters, event.max_rounds].min
  end

end
