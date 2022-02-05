# frozen_string_literal: true

class SpeedDate < ApplicationRecord
  has_many :speed_date_appointments
  has_many :daters, through: :speed_date_appointments
  belongs_to :event

  validates :round, presence: true
end
