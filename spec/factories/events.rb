# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "New Event #{n}" }
    starts_at { DateTime.current }
    rep { nil }
    organisation { build(:organisation) }
    max_rounds { 10 }
    matches_email_sent_at { nil }
  end
end
