# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildEvent do
  subject { described_class.new(title: title, date: date, rep_id: rep.id, organisation_id: organisation.id).call }

  let(:title) { 'Speed dating at Bar' }
  let(:date) { DateTime.current.beginning_of_minute }
  let(:organisation) { create(:organisation) }
  let(:rep) { create(:rep, organisation: organisation) }

  it 'builds an event with the correct attibutes' do
    expect(subject).to have_attributes(
      title: title,
      date: date,
      rep: rep,
      organisation: organisation
    )
  end
end