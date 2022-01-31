# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateDater do
  subject { described_class.new(name: name, email: email, password: password, phone_number: phone_number, gender: gender, event: event).call }

  let(:name) { Faker::Name.name }
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password }
  let(:phone_number) { Faker::PhoneNumber.phone_number }
  let(:gender) { %w[male female].sample }
  let(:event) { create(:event) }

  context 'when valid attributes are provided' do
    it 'returns a hash for the result' do
      expect(subject).to eq({ dater: Dater.last, success: true, errors: [] })
    end
    
    it 'creates a dater' do
      expect { subject }.to change(Dater, :count).from(0).to(1)
      expect(Dater.last).to have_attributes(
        name: name,
        email: email,
        phone_number: phone_number,
        gender: gender,
        event: event
      )
    end
  end
end