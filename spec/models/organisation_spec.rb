require 'rails_helper'

RSpec.describe Organisation, type: :model do
  it { should have_many(:admins)}
  it { should have_many(:reps)}
  it { should have_many(:events)}
end
