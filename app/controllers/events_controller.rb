class EventsController < ApplicationController
  def index
    @events = Event.paginate(page: params[:page])
  end
  
  def show
    @event = Event.find(params[:id])
    @speed_dates = SpeedDate.where(event: @event)
    @daters = Dater.where(event: @event).sort
    @female_daters = @daters.select {|dater| dater.gender == 'female' }
    @male_daters = @daters.select {|dater| dater.gender == 'male' }
    @dater_names = {}
    @female_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @male_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @rounds = [@female_daters.size, @male_daters.size].max
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:success] = "Event updated"
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event deleted"
    redirect_to events_url
  end

  
  private

    def event_params
      params.require(:event).permit(:title, :date)
    end
end
