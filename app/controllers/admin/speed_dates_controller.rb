# frozen_string_literal: true

class Admin::SpeedDatesController < ApplicationController
  include SpeedDatesScheduleInfo

  before_action :authenticate_admin!

  def index
    @event = Event.includes(speed_dates: [:dater, :datee]).find(permitted_params)
    return unless validate_organisation
    return unless @event.speed_dates.any?

    @female_daters = @event.female_daters.sort_by(&:name)

    initialize_speed_dates_info
    add_dater_names_for_dates
    add_dater_names_for_breaks
  end

  def create
    @event = Event.find(permitted_params)
    return unless validate_organisation

    @event.speed_dates.destroy_all
    CreateDatingSchedule.new(event: @event).call

    redirect_to admin_event_speed_dates_path(@event)
  end

  private

  def permitted_params
    params.require(:event_id)
  end

  def validate_organisation
    if @event.organisation == current_admin.organisation
      true
    else
      redirect_to admin_events_path
      false
    end
  end
end
