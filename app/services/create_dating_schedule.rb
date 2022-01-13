# frozen_string_literal: true

class CreateDatingSchedule
  def initialize(event:)
    @event = event
  end

  def call
    @females = Dater.where(event: event, gender: 'female').ids
    @males = Dater.where(event: event, gender: 'male').ids
    if females.count > males.count
      add_empty_dates(females.count, males)
    elsif males.count > females.count
      add_empty_dates(males.count, females)
    end
    (0..number_of_rounds - 1).to_a.map { |n| females.rotate(n).zip(males) }
  end

  private

  attr_accessor :event, :females, :males

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

end