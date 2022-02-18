# frozen_string_literal: true

class Rep::DatersController < ApplicationController
  include GeneratePossibleMatches
  include UpdateMatches

  before_action :authenticate_rep!

  def index
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_rep(@event)

    @daters = @event.daters.sort_by(&:name)
    @dater = Dater.new
  end

  def show
    @dater = Dater.find(permitted_parameters[:id])
    @event = @dater.event
    return unless validate_event_rep(@event)

    generate_possible_matches
  end

  def update
    dater = Dater.find(permitted_parameters[:id])
    return unless validate_event_rep(dater.event)

    update_matches(dater)
    redirect_to rep_event_matches_path(dater.event), notice: 'Matches updated'
  end

  def create
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_rep(@event)

    create_dater(rep_event_daters_path(@event))
  end

  def destroy
    dater = Dater.find(permitted_parameters[:id])
    event = dater.event
    return unless validate_event_rep(event)

    dater.destroy
    flash[:success] = 'Dater Deleted'

    redirect_to rep_event_daters_path(event)
  end

  private

  def permitted_parameters
    params.permit(:event_id, :id, dater: [:name, :email, :phone_number, :event_id, :gender, { matches: [] }])
  end

  def validate_event_rep(event)
    if event.rep == current_rep
      true
    else
      redirect_to rep_events_path
      false
    end
  end

  def create_dater(redirect_path)
    @dater = Dater.new(password: SecureRandom.hex(10), **permitted_parameters[:dater])
    result = @dater.save
    if result
      redirect_to redirect_path, notice: 'Dater added'
    else
      redirect_to redirect_path, alert: "Dater not added: #{@dater.errors.full_messages.join(', ')}"
    end
  end
end
