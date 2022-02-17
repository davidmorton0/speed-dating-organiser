# frozen_string_literal: true

class SpeedDate < ApplicationRecord
  belongs_to :dater, optional: true
  belongs_to :datee, class_name: 'Dater', optional: true
  belongs_to :event

  validates :round, presence: true
end
