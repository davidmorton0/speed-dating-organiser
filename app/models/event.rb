class Event < ApplicationRecord
  has_many :daters
  has_many :speed_dates
  belongs_to :rep

  validates :title, presence: true
  validates :date, presence: true

  def male_daters
    daters.where(gender: 'male')
  end

  def female_daters
    daters.where(gender: 'female')
  end
end
