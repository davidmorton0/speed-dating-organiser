# frozen_string_literal: true

class Rep::SpeedDatesController < ApplicationController
  include SpeedDatesScheduleInfo

  before_action :authenticate_rep!

  def index
    @event = Event.includes(speed_dates: [:dater, :datee]).find(permitted_params)
    validate_event_rep(@event)
    return unless @event.speed_dates.any?

    @female_daters = @event.female_daters.sort_by(&:name)

    initialize_speed_dates_info
    add_dater_names_for_dates
    add_dater_names_for_breaks
  end

  def create
    @event = Event.find(permitted_params)
    validate_event_rep(@event)

    @event.speed_dates.destroy_all
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
