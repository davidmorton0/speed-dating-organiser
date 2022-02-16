# frozen_string_literal: true

FactoryBot.define do
  factory :speed_date do
    event { build(:event) }
    round { 1 }
    dater { build(:dater) }
    datee { build(:dater) }
  end
end
