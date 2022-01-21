# frozen_string_literal: true

class AddEvent
  def initialize(title:, date:, rep_id:)
    @title = title
    @date = date
    @rep_id = rep_id
  end

  def call
    Event.create(title: title, date: date, rep_id: rep_id)
  end

  private

  attr_accessor :title, :date, :rep_id
end