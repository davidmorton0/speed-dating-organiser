# frozen_string_literal: true

class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @events = Event.where(organisation: current_admin.organisation)
      .includes(:daters, :rep)
      .order(:id)
      .paginate(page: params[:page])
  end

  def show
    @event = Event.find(show_event_params)
    return unless validate_organisation
  end

  def new
    @event = Event.new
  end

  def create # rubocop:disable Metrics/AbcSize
    title = event_params[:title]
    date = event_params[:date]
    rep = Rep.find_by(id: event_params[:rep_id])
    organisation = current_admin.organisation
    max_rounds = Constants::MAX_ROUNDS

    @event = Event.new(title: title, date: date, rep: rep, organisation: organisation, max_rounds: max_rounds)

    if validate_rep && @event.save
      flash[:success] = 'Event created'
      redirect_to admin_events_path
    else
      flash.now[:error] ||= @event.errors.full_messages.join(', ')
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
    return unless validate_organisation
  end

  def update # rubocop:disable Metrics/AbcSize
    @event = Event.find(params[:id])
    return unless validate_organisation

    if validate_rep && @event.update(event_params)
      flash[:success] = 'Event updated'
      redirect_to admin_event_path(@event)
    else
      flash.now[:error] ||= @event.errors.full_messages.join(', ')
      @event.reload
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
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
    params.require(:event).permit(:title, :date, :max_rounds, :rep_id)
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
end
