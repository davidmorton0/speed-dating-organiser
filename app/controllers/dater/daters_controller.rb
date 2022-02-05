class Dater::DatersController < ApplicationController
  before_action :authenticate_dater!

  def show
    @dater = current_dater
    @event = @dater.event

    if @dater.female?
      @possible = @event.male_daters
    elsif @dater.male?
      @possible = @event.female_daters
    end
    @possible_matches = @possible.map do |dater|
      {
        name: dater.name,
        id: dater.id,
        match: @dater.matches.include?(dater.id.to_s)
      }
    end
  end

  def update
    matches = params.keys.select { |key| current_dater.event.daters.ids.include?(key.to_i) }
    current_dater.update(matches: matches)

    redirect_to dater_event_path(current_dater.event), info: 'Matches updated'
  end
end

private

