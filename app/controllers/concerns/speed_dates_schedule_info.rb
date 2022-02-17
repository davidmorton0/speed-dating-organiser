# frozen_string_literal: true

module SpeedDatesScheduleInfo
  def initialize_speed_dates_info
    @speed_dates_info = Hash.new { |h, k| h[k] = {} }
  end

  def add_dater_names_for_dates
    @female_daters.map do |dater|
      dater.speed_dates.each do |speed_date|
        @speed_dates_info[speed_date.round][dater.id] = speed_date.datee&.name || 'Break'
      end
    end
  end

  def add_dater_names_for_breaks
    @event.speed_dates.select { |speed_date| @event.male_daters.include?(speed_date.dater) && speed_date.datee.nil? }
      .group_by(&:round)
      .each do |round, speed_dates|
      @speed_dates_info[round][:break] = speed_dates.map do |speed_date|
        speed_date.dater.name
      end.join(', ')
    end
  end
end
