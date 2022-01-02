# frozen_string_literal: true

class AddEvent
  def initialize(title:, date:)
    @title = title
    @date = date
  end

  def call
    Event.create(title: title, date: date)
  end

  private

  attr_accessor :title, :date
end