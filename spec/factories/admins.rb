FactoryBot.define do
  factory :admin do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    organisation { build(:organisation) }
  end
end
