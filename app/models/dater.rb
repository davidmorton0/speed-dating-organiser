class Dater < ApplicationRecord
  belongs_to :event
  has_many :speed_dates

  validates :name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :gender, inclusion: { in: %w[male female] }
end
