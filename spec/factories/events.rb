# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "New Event #{n}" }
    date { DateTime.current }
  end
end