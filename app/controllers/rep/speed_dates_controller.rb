# frozen_string_literal: true

class Rep::SpeedDatesController < ApplicationController
  before_action :authenticate_rep!
  
  def index
    @event = Event.find(params[:event_id])
    validate_event_rep(@event)

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
    validate_event_rep(@event)

    CreateDatingSchedule.new(event: @event).call
    redirect_to rep_event_speed_dates_path(@event)
  end

  private

  def permitted_params
    params.require(:event_id)
  end

  def validate_event_rep(event)
    redirect_to rep_events_path unless event.rep == current_rep
  end

end