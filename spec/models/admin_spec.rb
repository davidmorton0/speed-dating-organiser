require 'rails_helper'

RSpec.describe Admin, type: :model do
  it { should belong_to(:organisation) }
end
