# frozen_string_literal: true

module MatchImages
  MATCHER_IMAGES = {
    [true, true] => 'yes-yes.png',
    [true, false] => 'yes-no.png',
    [false, true] => 'no-yes.png',
    [false, false] => 'no-no.png',
  }.freeze

  private

  def match_image(dater1, dater2)
    matches = dater1.matches_with?(dater2)
    MATCHER_IMAGES[matches]
  end
end
