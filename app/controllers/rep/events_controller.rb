class Rep::EventsController < ApplicationController
  include MatchImages

  before_action :authenticate_rep!

  def index
    @events = Event.where(rep: current_rep)
      .includes(:daters)
      .order(:id)
      .reverse_order
      .paginate(page: params[:page])
  end

  def show
    @event = Event.find(event_params[:id])
    validate_event_rep(@event)
  end

  def matches
    @event = Event.includes(:daters, :rep).find(event_params[:event_id])
    return unless validate_event_rep(@event)

    @female_daters = @event.female_daters.sort_by(&:name)
    @male_daters = @event.male_daters.sort_by(&:name)
  end

  private

  helper_method :match_image

  def event_params
    params.permit(:id, :page, :event_id)
  end

  def validate_event_rep(event)
    if event.rep == current_rep
      true
    else
      redirect_to rep_events_path
      false
    end
  end
end
