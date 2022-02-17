# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :admins, dependent: :destroy
  has_many :reps, dependent: :destroy
  has_many :events, dependent: :destroy
end
