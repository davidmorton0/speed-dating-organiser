require 'rails_helper'

RSpec.describe Rep, type: :model do
  it { should belong_to(:organisation) }
  it { should have_many(:events)}
end
