class Dater::DatersController < ApplicationController
  before_action :authenticate_dater!

  def show
    @dater = current_dater
    @event = @dater.event

    gender_of_possible_matches = @dater.gender == 'female' ? 'male' : 'female'
    @possible_matches = Dater.where(event: @event, gender: gender_of_possible_matches)
  end

  def update
    matches = params.keys.select { |key| current_dater.event.daters.ids.include?(key.to_i) }
    current_dater.update(matches: matches)

    redirect_to dater_event_path(current_dater.event), info: 'Matches updated'
  end
end
