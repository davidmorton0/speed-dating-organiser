# frozen_string_literal: true

module MatchInformation

  MATCHER_IMAGES = {
    [true, true] => 'yes-yes.png',
    [true, false] => 'yes-no.png',
    [false, true] => 'no-yes.png',
    [false, false] => 'no-no.png',
  }.freeze

  private

  def generate_possible_matches
    @possible_matches = @event.daters.reject { |possible_match| possible_match.gender == @dater.gender }.sort_by(&:name)
    @possible_matches.each do |possible_match|
      possible_match.match = @dater.matches.include?(possible_match.id.to_s)
    end
  end

  def match_image(dater1, dater2)
    matches = dater1.matches_with?(dater2)
    MATCHER_IMAGES[matches]
  end

  def update_matches(dater)
    if permitted_parameters[:dater]
      matches = permitted_parameters[:dater][:matches].select(&:present?)
    else
      matches = []
    end
    dater.update(matches: matches)
  end
end