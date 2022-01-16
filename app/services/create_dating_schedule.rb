# frozen_string_literal: true

class CreateDatingSchedule
  def initialize(event:)
    @event = event
  end

  def call
    destroy_existing_speed_dates

    @females = Dater.where(event: event, gender: 'female').ids
    @males = Dater.where(event: event, gender: 'male').ids
    if females.count > males.count
      add_empty_dates(females.count, males)
    elsif males.count > females.count
      add_empty_dates(males.count, females)
    end
    schedule = (0..number_of_rounds - 1).to_a.map { |n| females.rotate(n).zip(males) }
    create_speed_dates(schedule)
    schedule
  end

  private

  attr_accessor :event, :females, :males

  def destroy_existing_speed_dates
    SpeedDate.where(event: event).destroy_all
  end

  def number_of_rounds
    [females.count, males.count].max
  end

  def add_empty_dates(total_dates, daters)
    difference_in_daters = total_dates - daters.count
    gap = total_dates.to_f / difference_in_daters
    (1..difference_in_daters).to_a.each do |n|
      daters.insert((n * gap).ceil - 1, nil)
    end
  end

  def create_speed_dates(schedule)
    schedule.each_with_index do |round, index|
      round.each do |speed_date|
        SpeedDate.create(event: event, round: index + 1, dater1_id: speed_date.first, dater2_id: speed_date.second)
      end
    end
  end

end