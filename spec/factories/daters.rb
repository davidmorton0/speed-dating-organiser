# frozen_string_literal: true

FactoryBot.define do
  factory :dater do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    phone_number { Faker::PhoneNumber.phone_number }
    gender { %w[male female].sample }
    event { build(:event) }

    trait :female do
      name { "#{Faker::Name.female_first_name} #{Faker::Name.last_name}" }
      gender { 'female' }
    end

    trait :male do
      name { "#{Faker::Name.male_first_name} #{Faker::Name.last_name}" }
      gender { 'male' }
    end
  end


end
