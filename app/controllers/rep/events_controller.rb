class Rep::EventsController < ApplicationController
  before_action :authenticate_rep!

  def index
    @events = Event.where(rep: current_rep)
    .includes(:daters)
    .order(:id)
    .reverse_order
    .paginate(page: params[:page])
  end

  def show # rubocop:disable Metrics/AbcSize
    @event = Event.find(event_params[:id])
    redirect_to rep_events_path unless @event.rep == current_rep

    @speed_dates = SpeedDate.where(event: @event)
    @daters = Dater.where(event: @event).sort
    @female_daters = @daters.select { |dater| dater.gender == 'female' }
    @male_daters = @daters.select { |dater| dater.gender == 'male' }
    @dater_names = {}
    @female_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @male_daters.each { |dater| @dater_names[dater.id] = dater.name }
    @rounds = [@female_daters.size, @male_daters.size].max
  end

  private

  def event_params
    params.permit(:id, :page)
  end
end
