# frozen_string_literal: true

module GeneratePossibleMatches
  private

  def generate_possible_matches
    @possible_matches = @event.daters.reject { |possible_match| possible_match.gender == @dater.gender }.sort_by(&:name)
    @possible_matches.each do |possible_match|
      possible_match.match = @dater.matches.include?(possible_match.id.to_s)
    end
  end
end
