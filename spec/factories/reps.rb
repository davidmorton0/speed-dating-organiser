FactoryBot.define do
  factory :rep do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    organisation { build(:organisation) }
  end
end
