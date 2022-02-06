class Dater::DatersController < ApplicationController
  before_action :authenticate_dater!

  def show
    @dater = current_dater
    @event = @dater.event

    @potential_matches = @event.daters
                    .select { |dater| dater.gender != @dater.gender }
    @potential_matches.each { |dater| dater.match = @dater.matches.include?(dater.id.to_s) }
  end

  def update
    matches = params.keys.select { |key| current_dater.event.daters.ids.include?(key.to_i) }
    current_dater.update(matches: matches)

    redirect_to dater_event_path(current_dater.event), info: 'Matches updated'
  end
end

private

