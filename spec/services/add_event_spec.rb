# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddEvent do
  subject { described_class.new(title: title, date: date, rep_id: rep.id).call }

  let(:title) { 'Speed dating at Bar' }
  let(:date) { DateTime.current.beginning_of_minute }
  let(:rep) { create(:rep) }

  it 'creates an event' do
    expect { subject }.to change(Event, :count).from(0).to(1)
    new_event = Event.last
    expect(new_event).to have_attributes(
      title: title,
      date: date,
      rep: rep
    )
  end
end