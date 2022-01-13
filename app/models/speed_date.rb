class SpeedDate < ApplicationRecord
  belongs_to :dater_1, class_name: 'Dater'
  belongs_to :dater_2, class_name: 'Dater'
  belongs_to :event

  validates :round, presence: true
end
