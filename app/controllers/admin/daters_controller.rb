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
  end

  def show
    @dater = Dater.find(params[:id])
    @event = @dater.event
    gender_of_possible_matches = (%w[female male] - [@dater.gender]).first
    @possible_matches = @event.daters.where(gender: gender_of_possible_matches)
  end

  def matches
    @event = Event.find(params[:event_id])
    @female_daters = @event.daters.where(gender: 'female')
    @male_daters = @event.daters.where(gender: 'male')
  end

  def send_match_emails
    @event = Event.find(params[:event_id])
    @event.daters.each_with_index do |dater1, index|
      matches = @event.daters.select { |dater2| dater1.matches_with?(dater2).all? }
      DaterMailer.with(dater: dater1, matches: matches).matches_email.deliver_later(wait: (index * 3).seconds)
    end

    redirect_to admin_event_matches_path(@event), info: 'Match Emails Sent'
  end

  def update
    dater = Dater.find(params[:id])
    matches = params.keys.select { |key| dater.event.daters.ids.include?(key.to_i) }
    dater.update(matches: matches)

    redirect_to admin_event_matches_path(dater.event), info: 'Matches updated'
  end

  def create
    @dater = Dater.new(dater_params)
    if @dater.email.present?
      @dater.invite!
      @dater.update(name: "Dater #{@dater.id}") unless @dater.name.present?
      flash[:success] = 'Dater Invited'
      redirect_to admin_event_daters_path(@dater.event)
    else
      redirect_to admin_event_daters_path(@dater.event), alert: 'Email address must be entered'
    end
  end

  private

  def dater_params
    params.permit(:name, :email, :phone_number, :gender, :event_id)
  end

  def match_image(dater_1, dater_2)
    matches = dater_1.matches_with?(dater_2)
    MATCHER_IMAGES[matches]
  end

  helper_method :match_image
end
