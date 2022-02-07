class Dater::DatersController < ApplicationController
  before_action :authenticate_dater!

  def show
    @dater = current_dater
    @event = @dater.event

    @possible_matches = @event.daters.reject { |possible_match| possible_match.gender == @dater.gender }
    @possible_matches.each do |possible_match|
      possible_match.match = @dater.matches.include?(possible_match.id.to_s)
    end
  end

  def update
    matches = permitted_parameters[:dater][:matches].select(&:present?)
    current_dater.update(matches: matches)

    redirect_to dater_event_path(current_dater.event), info: 'Matches updated'
  end
end

private

def permitted_parameters
  params.permit(dater: { matches: [] })
end
