# frozen_string_literal: true

class Rep < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :organisation
  has_many :events
end
