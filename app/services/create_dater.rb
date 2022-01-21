# frozen_string_literal: true

class CreateDater
  def initialize(name:, email:, password:, phone_number:, gender:, event:)
    @name = name
    @email = email
    @password = password
    @phone_number = phone_number
    @gender = gender
    @event = event
  end

  def call
    dater = Dater.new(name: name, email: email, password: password, phone_number: phone_number, gender: gender, event: event)
    result = dater.save
    { dater: dater, success: result, errors: dater.errors.full_messages }
  end

  private

  attr_accessor :name, :email, :password, :phone_number, :gender, :event
end