FactoryBot.define do
  factory :dater do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    gender { %w[male female].sample }
    event { build(:event) }
  end
end
