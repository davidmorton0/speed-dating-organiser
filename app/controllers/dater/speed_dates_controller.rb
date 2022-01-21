# frozen_string_literal: true

class Dater::SpeedDatesController < ApplicationController
  before_action :authenticate_dater!
  
  def index
    @event = current_dater.event
    @speed_dates = @event.speed_dates
    @daters = @event.daters
    @female_daters = @daters.select {|dater| dater.gender == 'female' }
    @male_daters = @daters.select {|dater| dater.gender == 'male' }
    @dater_names = {}
    @female_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @male_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @rounds = [@female_daters.size, @male_daters.size].max
  end

  private

  def permitted_params
    params.require(:event_id)
  end

end