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
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_rep(@event)

    @daters = @event.daters.sort_by(&:name)
    @dater = Dater.new
  end

  def show
    @event = Event.find(permitted_parameters[:event_id])
    @dater = Dater.find(permitted_parameters[:id])
    return unless validate_event_rep(@event)

    redirect_to rep_event_path(@event), alert: 'Dater not part of this event' unless @dater.event == @event

    generate_possible_matches
  end

  def matches
    @event = Event.includes(:daters, :rep).find(permitted_parameters[:event_id])
    return unless validate_event_rep(@event)

    @female_daters = @event.female_daters
    @male_daters = @event.male_daters
  end

  def update
    dater = Dater.find(permitted_parameters[:id])
    matches = permitted_parameters[:dater][:matches].select(&:present?)
    return unless validate_event_rep(dater.event)

    dater.update(matches: matches)
    redirect_to rep_event_matches_path(dater.event), notice: 'Matches updated'
  end

  def create
    @event = Event.find(permitted_parameters[:event_id])
    return unless validate_event_rep(@event)

    @dater = Dater.new(password: SecureRandom.hex(10), **permitted_parameters[:dater])
    result = @dater.save
    if result
      redirect_to rep_event_daters_path(@event), notice: 'Dater added'
    else
      redirect_to rep_event_daters_path(@event), alert: "Dater not added: #{@dater.errors.full_messages.join(', ')}"
    end
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

  def generate_possible_matches
    @possible_matches = @event.daters.reject { |possible_match| possible_match.gender == @dater.gender }
    @possible_matches.each do |possible_match|
      possible_match.match = @dater.matches.include?(possible_match.id.to_s)
    end
  end

  def match_image(dater1, dater2)
    matches = dater1.matches_with?(dater2)
    MATCHER_IMAGES[matches]
  end

  helper_method :match_image
end
