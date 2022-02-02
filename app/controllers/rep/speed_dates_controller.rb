# frozen_string_literal: true

class Rep::SpeedDatesController < ApplicationController
  before_action :authenticate_rep!

  def index
    @event = Event.includes(:daters, :speed_dates).find(permitted_params)
    validate_event_rep(@event)

    @rounds = @event.speed_dates.map(&:round).max
    return unless @rounds

    @female_daters = Dater.where(event: @event, gender: 'female')
    dater_names = @event.daters.to_h { |dater| [dater.id, dater.name] }

    @schedule_info = Array.new(@rounds) { Hash.new('') }
    @event.speed_dates.each do |speed_date|
      if speed_date.dater1_id
        @schedule_info[speed_date.round - 1][speed_date.dater1_id] = dater_names[speed_date.dater2_id]
      else
        @schedule_info[speed_date.round - 1][:break] += ', ' if @schedule_info[speed_date.round - 1][:break].present?
        @schedule_info[speed_date.round - 1][:break] += dater_names[speed_date.dater2_id]
      end
    end
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
