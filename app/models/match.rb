class Match < ApplicationRecord
  belongs_to :matcher, foreign_key: "matcher_id", class_name: "Dater"
  belongs_to :matchee, foreign_key: "matchee_id", class_name: "Dater"
end
