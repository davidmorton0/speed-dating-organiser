class Organisation < ApplicationRecord
  has_many :admins
  has_many :reps
  has_many :events
end
