class Admin::DatersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @event = Event.find(params[:event_id])
    @speed_dates = SpeedDate.where(event: @event)
    @daters = Dater.where(event: @event)
    @female_daters = @daters.select {|dater| dater.gender == 'female' }
    @male_daters = @daters.select {|dater| dater.gender == 'male' }
    @dater_names = {}
    @female_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @male_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @rounds = [@female_daters.size, @male_daters.size].max
  end

  def show
    @event = Event.find(params[:event_id])
    @dater = Dater.find(params[:id])
    gender_of_possible_matches = @dater.gender == 'female' ? 'male' : 'female'
    @possible_matches = Dater.where(event: @event, gender: gender_of_possible_matches)
  end

  def update
    dater = Dater.find(params[:id])
    matches = params.keys.select { |key| dater.event.daters.ids.include?(key.to_i) }
    dater.update(matches: matches)

    redirect_to admin_event_daters_path(dater.event), info: "Matches updated"
  end

  def create
    @dater = Dater.new(dater_params)
    result = @dater.save
    event = Event.find(@dater.event.id)
    if result
      redirect_to admin_event_daters_path(event), info: "Dater added"
    else
      redirect_to admin_event_daters_path(event), alert: "Dater not added: #{@dater.errors.full_messages.join(", ")}"
    end
  end
  
  private

    def dater_params
      params.permit(:name, :email, :phone_number, :gender, :event_id)
    end
end
