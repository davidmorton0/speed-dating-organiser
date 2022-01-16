FactoryBot.define do
  factory :match do
    matcher { build(:dater) }
    matchee { build(:dater) }
  end
end
