class Dater < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :event
  has_many :speed_dates

  has_many :matcher_matches, foreign_key: :matchee_id, class_name: "Match"
  has_many :matchers, through: :matcher_matches, source: :matcher
  has_many :matchee_matches, foreign_key: :matcher_id, class_name: "Match"
  has_many :matchees, through: :matchee_matches, source: :matchee

  validates :name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :gender, inclusion: { in: %w[male female] }

  def matches_with(dater)
    [matches.include?(dater.id.to_s), dater.matches.include?(id.to_s)]
  end
end
