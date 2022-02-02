class Dater::EventsController < ApplicationController
  before_action :authenticate_dater!

  def show
    @event = current_dater.event
  end
end
