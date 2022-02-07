# frozen_string_literal: true

class Dater::SpeedDatesController < ApplicationController
  before_action :authenticate_dater!

  def index
    @event = Event.includes(speed_dates: [:dater, :datee]).find(permitted_params)
    return unless @event.speed_dates.any?

    @female_daters = @event.female_daters.sort_by(&:name)
    
    @speed_dates_info = Hash.new { |h, k| h[k] = {} }
    @female_daters.map do |dater|
      dater.speed_dates.each do |speed_date|
        @speed_dates_info[speed_date.round][dater.id] = speed_date.datee&.name || 'Break'
      end
    end
    @event.speed_dates.select { |speed_date| @event.male_daters.include?(speed_date.dater) && speed_date.datee.nil? }
                      .group_by(&:round)
                      .each do |round, speed_dates|
                        @speed_dates_info[round][:break] = speed_dates.map { |speed_date| speed_date.dater.name }.join(', ')
                      end
  end

  private

  def permitted_params
    params.require(:event_id)
  end
end
