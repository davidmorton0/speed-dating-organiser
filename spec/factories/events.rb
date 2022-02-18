# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    sequence(:location) do |n|
      "#{Faker::Color.color_name} Bar #{n}, #{Faker::Address.street_address}, " \
        "#{Faker::Address.city_prefix}#{Faker::Address.city_suffix}"
    end
    sequence(:title) { |n| "New Event #{n}" }
    starts_at { DateTime.current }
    rep { nil }
    organisation { build(:organisation) }
    max_rounds { 10 }
    matches_email_sent_at { nil }
  end
end
