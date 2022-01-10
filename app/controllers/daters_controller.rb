class DatersController < ApplicationController
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
