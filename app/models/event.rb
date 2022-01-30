class Event < ApplicationRecord
  has_many :daters
  has_many :speed_dates
  belongs_to :rep, optional: true
  belongs_to :organisation

  validates :title, presence: true
  validates :date, presence: true
  validate :rep_must_belong_to_organisation

  def male_daters
    daters.where(gender: 'male')
  end

  def female_daters
    daters.where(gender: 'female')
  end

  def rep_must_belong_to_organisation
    if rep.present? && rep.organisation != organisation
      errors.add(:rep, 'does not belong to this organisation')
    end
  end
end
