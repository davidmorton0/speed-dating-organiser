class Event < ApplicationRecord
  has_many :daters
  has_many :speed_dates

  validates :title, presence: true
  validates :date, presence: true
end
