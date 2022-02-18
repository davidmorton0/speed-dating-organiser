# frozen_string_literal: true

class Dater::SpeedDatesController < ApplicationController
  include SpeedDatesScheduleInfo

  before_action :authenticate_dater!

  def index
    @event = Event.includes(speed_dates: [:dater, :datee]).find(permitted_params)
    return unless @event.speed_dates.any?

    @female_daters = @event.female_daters.sort_by(&:name)

    initialize_speed_dates_info
    add_dater_names_for_dates
    add_dater_names_for_breaks
  end

  private

  def permitted_params
    params.require(:event_id)
  end

  def add_dater_names_for_dates
    @female_daters.map do |dater|
      dater.speed_dates.each do |speed_date|
        @speed_dates_info[speed_date.round][dater.id] = if speed_date.datee
                                                          dater_name_info(speed_date.datee)
                                                        else
                                                          'Break'
                                                        end
      end
    end
  end

  def add_dater_names_for_breaks
    @event.speed_dates.select { |speed_date| @event.male_daters.include?(speed_date.dater) && speed_date.datee.nil? }
      .group_by(&:round)
      .each do |round, speed_dates|
      @speed_dates_info[round][:break] = speed_dates.map do |speed_date|
        dater_name_info(speed_date.dater)
      end.join(', ')
    end
  end
end
