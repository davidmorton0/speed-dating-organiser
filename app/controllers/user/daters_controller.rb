class User::DatersController < ApplicationController
  before_action :authenticate_user!

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

    redirect_to user_event_path(dater.event), info: "Matches updated"
  end
  
  private

    def dater_params
      params.permit(:name, :email, :phone_number, :gender, :event_id)
    end
end
