# frozen_string_literal: true

class SpeedDatesController < ApplicationController
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