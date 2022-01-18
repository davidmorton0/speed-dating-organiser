FactoryBot.define do
  factory :rep do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
