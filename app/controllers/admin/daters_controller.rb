class Admin::DatersController < ApplicationController
  before_action :authenticate_admin!

  MATCHER_IMAGES = {
    [true, true] => 'yes-yes.png',
    [true, false] => 'yes-no.png',
    [false, true] => 'no-yes.png',
    [false, false] => 'no-no.png',
  }.freeze

  private_constant :MATCHER_IMAGES

  def index
    @event = Event.find(params[:event_id])
    @daters = @event.daters.sort_by(&:name)

    @dater = Dater.new
  end

  def show
    @dater = Dater.find(params[:id])
    @event = @dater.event
    return unless validate_event_admin(@event)

    gender_of_possible_matches = (%w[female male] - [@dater.gender]).first
    @possible_matches = @event.daters.where(gender: gender_of_possible_matches)
  end

  def matches
    @event = Event.find(params[:event_id])
    return unless validate_event_admin(@event)

    @female_daters = @event.female_daters
    @male_daters = @event.male_daters
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
    matches = permitted_parameters[:dater][:matches].select(&:present?)
    return unless validate_event_admin(dater.event)

    dater.update(matches: matches)
    redirect_to admin_event_matches_path(dater.event), notice: 'Matches updated'
  end

  def create
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_admin(@event)

    @dater = Dater.new(password: SecureRandom.hex(10), **permitted_parameters[:dater])
    result = @dater.save
    if result
      redirect_to admin_event_daters_path(@event), notice: 'Dater added'
    else
      redirect_to admin_event_daters_path(@event), alert: "Dater not added: #{@dater.errors.full_messages.join(', ')}"
    end
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

  def match_image(dater1, dater2)
    matches = dater1.matches_with?(dater2)
    MATCHER_IMAGES[matches]
  end

  helper_method :match_image
end
