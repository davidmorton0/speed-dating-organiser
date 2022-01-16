class DatersController < ApplicationController

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

  def create
    @dater = Dater.new(dater_params)
    result = @dater.save
    event = Event.find(@dater.event.id)
    if result
      redirect_to event_path(event), info: "Dater added"
    else
      redirect_to event_path(event), alert: "Dater not added: #{@dater.errors.full_messages.join(", ")}"
    end
  end
  
  private

    def dater_params
      params.permit(:name, :email, :phone_number, :gender, :event_id)
    end
end
