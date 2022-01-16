# frozen_string_literal: true

class SpeedDatesController < ApplicationController

  def index
    @event = Event.find(params[:event_id])
    @speed_dates = SpeedDate.where(event: @event)
    @daters = Dater.where(event: @event)
    @female_daters = @daters.select {|dater| dater.gender == 'female' }
    @male_daters = @daters.select {|dater| dater.gender == 'male' }
    @dater_names = {}
    @female_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @male_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @rounds = [@female_daters.size, @male_daters.size].max
  end
  
  def create
    @event = Event.find(permitted_params)
    CreateDatingSchedule.new(event: @event).call

    redirect_to @event
  end

  private

  def permitted_params
    params.require(:event_id)
  end

end