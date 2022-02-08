class Rep::DatersController < ApplicationController
  before_action :authenticate_rep!

  MATCHER_IMAGES = {
    [true, true] => 'yes-yes.png',
    [true, false] => 'yes-no.png',
    [false, true] => 'no-yes.png',
    [false, false] => 'no-no.png',
  }.freeze

  private_constant :MATCHER_IMAGES

  def index
    @event = Event.find(params[:event_id])
    return unless validate_event_rep(@event)

    @daters = @event.daters.sort_by(&:name)
  end

  def show
    @event = Event.find(params[:event_id])
    @dater = Dater.find(params[:id])
    return unless validate_event_rep(@event)
    redirect_to rep_event_path(@event), alert: 'Dater not part of this event' unless @dater.event == @event

    @possible_matches = @event.daters.reject { |possible_match| possible_match.gender == @dater.gender }
    @possible_matches.each do |possible_match|
      possible_match.match = @dater.matches.include?(possible_match.id.to_s)
    end
  end

  def matches
    @event = Event.includes(:daters, :rep).find(params[:event_id])
    return unless validate_event_rep(@event)

    @female_daters = @event.female_daters
    @male_daters = @event.male_daters
  end

  def update
    dater = Dater.find(params[:id])
    matches = permitted_parameters[:dater][:matches].select(&:present?)
    return unless validate_event_rep(dater.event)

    dater.update(matches: matches)
    redirect_to rep_event_matches_path(dater.event), notice: 'Matches updated'
  end

  def create
    @event = Event.find(params[:event_id])
    return unless validate_event_rep(@event)

    @dater = Dater.new(dater_params)
    result = @dater.save
    if result
      redirect_to rep_event_daters_path(event), notice: 'Dater added'
    else
      redirect_to rep_event_daters_path(event), alert: "Dater not added: #{@dater.errors.full_messages.join(', ')}"
    end
  end

  private

  def permitted_parameters
    params.permit(dater: { matches: [] })
  end

  def dater_params
    params.permit(:name, :email, :phone_number, :gender, :event_id)
  end

  def validate_event_rep(event)
    if event.rep == current_rep
      true
    else
      redirect_to rep_events_path
      false
    end
  end

  def match_image(dater1, dater2)
    matches = dater1.matches_with?(dater2)
    MATCHER_IMAGES[matches]
  end

  helper_method :match_image
end
