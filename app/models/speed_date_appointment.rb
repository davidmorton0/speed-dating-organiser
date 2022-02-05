# frozen_string_literal: true

class SpeedDateAppointment < ApplicationRecord
  belongs_to :dater
  belongs_to :speed_date
end
