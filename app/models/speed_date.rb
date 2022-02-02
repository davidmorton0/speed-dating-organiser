class SpeedDate < ApplicationRecord
  belongs_to :dater1, class_name: 'Dater', optional: true
  belongs_to :dater2, class_name: 'Dater', optional: true
  belongs_to :event

  validates :round, presence: true
end
