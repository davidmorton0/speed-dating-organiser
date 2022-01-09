class Event < ApplicationRecord
  has_many :daters

  validates :title, presence: true
  validates :date, presence: true
end
