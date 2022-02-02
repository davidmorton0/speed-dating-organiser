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
    validate_event_rep(@event)

    @daters = @event.daters.sort_by(&:name)
  end

  def show
    @event = Event.find(params[:event_id])
    validate_event_rep(@event)

    @dater = Dater.find(params[:id])
    gender_of_possible_matches = @dater.gender == 'female' ? 'male' : 'female'
    @possible_matches = Dater.where(event: @event, gender: gender_of_possible_matches)
  end

  def matches
    @event = Event.find(params[:event_id])
    validate_event_rep(@event)

    @female_daters = @event.daters.where(gender: 'female')
    @male_daters = @event.daters.where(gender: 'male')
  end

  def update
    dater = Dater.find(params[:id])
    validate_event_rep(dater.event)

    matches = params.keys.select { |key| dater.event.daters.ids.include?(key.to_i) }
    dater.update(matches: matches)

    redirect_to rep_event_matches_path(dater.event), info: 'Matches updated'
  end

  def create
    @event = Event.find(params[:event_id])
    validate_event_rep(@event)

    @dater = Dater.new(dater_params)
    result = @dater.save
    if result
      redirect_to rep_event_daters_path(event), info: 'Dater added'
    else
      redirect_to rep_event_daters_path(event), alert: "Dater not added: #{@dater.errors.full_messages.join(', ')}"
    end
  end

  private

  def dater_params
    params.permit(:name, :email, :phone_number, :gender, :event_id)
  end

  def validate_event_rep(event)
    redirect_to rep_events_path unless event.rep == current_rep
  end

  def match_image(dater1, dater2)
    matches = dater1.matches_with(dater2)
    MATCHER_IMAGES[matches]
  end

  helper_method :match_image
end
