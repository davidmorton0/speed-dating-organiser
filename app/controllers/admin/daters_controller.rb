# frozen_string_literal: true

class Admin::DatersController < ApplicationController
  include MatchInformation

  before_action :authenticate_admin!

  def index
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_admin(@event)

    @daters = @event.daters.sort_by(&:name)
    @dater = Dater.new
  end

  def show
    @dater = Dater.find(permitted_parameters[:id])
    @event = @dater.event
    return unless validate_event_admin(@event)

    redirect_to rep_event_path(@event), alert: 'Dater not part of this event' unless @dater.event == @event

    generate_possible_matches
  end

  def matches
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_admin(@event)

    @female_daters = @event.female_daters.sort_by(&:name)
    @male_daters = @event.male_daters.sort_by(&:name)
  end

  def send_match_emails
    @event = Event.find(params[:event_id])
    return unless validate_event_admin(@event)

    @event.daters.each_with_index do |dater1, index|
      send_match_email(dater1, index)
    end

    redirect_to admin_event_matches_path(@event), notice: 'Match Emails Sent'
  end

  def update
    dater = Dater.find(permitted_parameters[:id])
    return unless validate_event_admin(dater.event)

    update_matches(dater)
    redirect_to admin_event_matches_path(dater.event), notice: 'Matches updated'
  end

  def create
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_admin(@event)

    create_dater(admin_event_daters_path(@event))
  end

  def destroy
    dater = Dater.find(permitted_parameters[:id])
    event = dater.event
    return unless validate_event_admin(event)

    dater.destroy
    flash[:success] = 'Dater Deleted'

    redirect_to admin_event_daters_path(event)
  end

  private

  helper_method :match_image

  def permitted_parameters
    params.permit(:event_id, :id, dater: [:name, :email, :phone_number, :event_id, :gender, { matches: [] }])
  end

  def validate_event_admin(event)
    if event.organisation == current_admin.organisation
      true
    else
      redirect_to admin_events_path
      false
    end
  end

  def send_match_email(dater1, index)
    matches = @event.daters.select { |dater2| dater1.matches_with?(dater2).all? }
    DaterMailer.matches_email(dater1, matches).deliver_later(wait: (index * 3).seconds)
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
