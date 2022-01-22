class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @events = Event.where(organisation: current_admin.organisation)
                   .includes(:daters)
                   .order(:id)
                   .paginate(page: params[:page])
  end
  
  def show
    @event = Event.find(params[:id])
    return unless validate_organisation

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
    @event = Event.new(event_params.merge(organisation_id: current_admin.organisation_id))

    if validate_rep && @event.save
      flash[:success] = "Event created"
      redirect_to admin_events_path
    else
      flash[:error] ||= @event.errors.full_messages.join(', ')
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    return unless validate_organisation
  end

  def update
    @event = Event.find(params[:id])
    return unless validate_organisation

    if validate_rep && @event.update(event_params)
      flash[:success] = "Event updated"
      redirect_to admin_event_path(@event)
    else
      flash[:error] ||= @event.errors.full_messages.join(', ')
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    return unless validate_organisation

    @event.destroy
    flash[:success] = "Event deleted"
    
    redirect_to admin_events_path
  end

  
  private

    def event_params
      params.require(:event).permit(:title, :date, :rep_id)
    end

    def validate_organisation
      if @event.organisation == current_admin.organisation
        true
      else
        redirect_to admin_events_path
        false
      end
    end

    def validate_rep
      return true unless event_params[:rep_id] && event_params[:rep_id].present?

      if current_admin.organisation.reps.ids.include?(event_params[:rep_id].to_i)
        true
      else
        flash[:error] = 'Assigned Rep is not from this organisation'
        false
      end
    end
end
