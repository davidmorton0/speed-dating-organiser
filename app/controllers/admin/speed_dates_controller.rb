# frozen_string_literal: true

class Admin::SpeedDatesController < ApplicationController
  before_action :authenticate_admin!

  def index # rubocop:disable Metrics/AbcSize
    @event = Event.includes(:daters, :speed_dates).find(permitted_params)
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
    @event.speed_dates.destroy_all
    CreateDatingSchedule.new(event: @event).call

    redirect_to admin_event_speed_dates_path(@event)
  end

  private

  def permitted_params
    params.require(:event_id)
  end
end
