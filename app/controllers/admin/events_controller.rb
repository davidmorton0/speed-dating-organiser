# frozen_string_literal: true

class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @events = Event.where(organisation: current_admin.organisation)
      .includes(:daters, :rep)
      .order(:id)
      .reverse_order
      .paginate(page: params[:page])
  end

  def show
    find_event
    return unless validate_organisation
  end

  def new
    @event = Event.new
  end

  def create
    create_event

    if validate_rep && @event.save
      flash[:success] = 'Event created'
      redirect_to admin_events_path
    else
      add_errors_to_flash
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    find_event
    return unless validate_organisation
  end

  def update
    find_event
    return unless validate_organisation

    if validate_rep && @event.update(event_params)
      flash[:success] = 'Event updated'
      redirect_to admin_event_path(@event)
    else
      add_errors_to_flash
      @event.reload
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    find_event
    return unless validate_organisation

    @event.destroy
    flash[:success] = 'Event deleted'

    redirect_to admin_events_path
  end

  private

  def show_event_params
    params.require(:id)
  end

  def event_params
    params.require(:event).permit(:title, :starts_at, :max_rounds, :rep_id)
  end

  def find_event
    @event = Event.find(show_event_params)
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
    return true unless event_params[:rep_id]&.present?

    if current_admin.organisation.reps.ids.include?(event_params[:rep_id].to_i)
      true
    else
      flash[:error] = 'Assigned Rep is not from this organisation'
      false
    end
  end

  def create_event
    @event = Event.new(
      title: event_params[:title],
      starts_at: event_params[:starts_at],
      rep_id: event_params[:rep_id],
      organisation: current_admin.organisation,
      max_rounds: Constants::MAX_ROUNDS,
    )
  end

  def add_errors_to_flash
    flash.now[:error] ||= @event.errors.full_messages.join(', ')
  end
end
