# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateDater do
  subject do
    described_class.new(params).call
  end

  let(:params) do
    {
      first_name: first_name,
      surname: surname,
      email: email,
      password: password,
      phone_number: phone_number,
      gender: gender,
      event: event,
    }
  end

  let(:first_name) { Faker::Name.first_name }
  let(:surname) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password }
  let(:phone_number) { Faker::PhoneNumber.phone_number }
  let(:gender) { %w[male female].sample }
  let(:event) { create(:event) }

  context 'when valid attributes are provided' do
    it 'returns a hash for success' do
      expect(subject).to include(
        dater: Dater.last,
        success: true,
        errors: [],
      )
    end

    it 'creates a dater' do
      expect { subject }.to change(Dater, :count).from(0).to(1)
      expect(Dater.last).to have_attributes(
        first_name: first_name,
        surname: surname,
        email: email,
        phone_number: phone_number,
        gender: gender,
        event: event,
      )
    end
  end

  context 'when invalid attributes are provided' do
    let(:email) { '' }

    it 'returns a hash with the errors' do
      expect(subject).to include(
        dater: an_instance_of(Dater),
        success: false,
        errors: ["Email can't be blank"],
      )
    end

    it 'does not create a dater' do
      expect { subject }.not_to change(Dater, :count)
    end
  end
end
