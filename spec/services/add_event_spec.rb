# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddEvent do
  subject { described_class.new(title: title, date: date).call }

  let(:title) { 'Speed dating at Bar' }
  let(:date) { DateTime.current.beginning_of_minute }

  it 'creates an event' do
    expect { subject }.to change(Event, :count).from(0).to(1)
    expect(Event.last.title).to eq title
    expect(Event.last.date).to eq date
  end
end