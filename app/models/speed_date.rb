class SpeedDate < ApplicationRecord
  belongs_to :dater1, class_name: 'Dater', required: false
  belongs_to :dater2, class_name: 'Dater', required: false
  belongs_to :event

  validates :round, presence: true
end
