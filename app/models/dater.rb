# frozen_string_literal: true

class Dater < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :event
  has_many :speed_dates

  validates :email, presence: true

  attr_accessor :match

  def matches_with?(dater)
    [matches.include?(dater.id.to_s), dater.matches.include?(id.to_s)]
  end

  def female?
    gender == 'female'
  end

  def male?
    gender == 'male'
  end
end
