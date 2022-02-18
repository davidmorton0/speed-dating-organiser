# frozen_string_literal: true

module UpdateMatches
  private

  def update_matches(dater)
    matches = if permitted_parameters[:dater]
                permitted_parameters[:dater][:matches].select(&:present?)
              else
                []
              end
    dater.update(matches: matches)
  end
end
