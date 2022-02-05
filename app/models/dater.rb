# frozen_string_literal: true

class Dater < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :event
  has_many :speed_date_appointments
  has_many :speed_dates, through: :speed_date_appointments

  validates :email, presence: true

  def matches_with?(dater)
    [matches.include?(dater.id.to_s), dater.matches.include?(id.to_s)]
  end
end
