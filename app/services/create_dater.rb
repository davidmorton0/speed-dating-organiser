# frozen_string_literal: true

class CreateDater
  def initialize(params)
    @params = params
  end

  def call
    dater = Dater.new(**params)
    result = dater.save
    { dater: dater, success: result, errors: dater.errors.full_messages }
  end

  private

  attr_accessor :params
end
