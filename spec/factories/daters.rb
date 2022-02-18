# frozen_string_literal: true

FactoryBot.define do
  factory :dater do
    first_name { Faker::Name.first_name }
    surname { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
    phone_number { Faker::PhoneNumber.phone_number }
    gender { %w[male female].sample }
    event { build(:event) }

    trait :female do
      first_name { Faker::Name.female_first_name.to_s }
      gender { 'female' }
    end

    trait :male do
      first_name { Faker::Name.male_first_name.to_s }
      gender { 'male' }
    end
  end
end
