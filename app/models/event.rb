# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :daters
  has_many :speed_dates

  belongs_to :organisation
  belongs_to :rep, optional: true

  validates :title, presence: true
  validates :date, presence: true
  validate :rep_must_belong_to_organisation

  def rep_must_belong_to_organisation
    errors.add(:rep, 'does not belong to this organisation') if rep.present? && rep.organisation != organisation
  end

  def female_daters
    daters.select { |dater| dater.gender == 'female' }
  end

  def male_daters
    daters.select { |dater| dater.gender == 'male' }
  end
end
