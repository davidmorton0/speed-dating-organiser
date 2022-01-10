require 'rails_helper'

RSpec.describe Dater, type: :model do
  it { should belong_to(:event) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.to validate_inclusion_of(:gender).in_array(%w[male female]) }

end
