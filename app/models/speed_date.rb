class SpeedDate < ApplicationRecord
  belongs_to :dater1, class_name: 'Dater'
  belongs_to :dater2, class_name: 'Dater'
  belongs_to :event

  validates :round, presence: true
end
