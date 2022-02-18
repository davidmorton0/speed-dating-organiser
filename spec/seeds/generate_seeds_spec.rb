# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateSeeds do

  it 'generates the seeds' do
    #binding.pry
    expect { described_class.new.call }.to(
    change(Admin, :count).to(2)
      .and(change(Organisation, :count).to(2))
      .and(change(Rep, :count).to(3))
      .and(change(Dater, :count).to(65))
      .and(change(Event, :count).to(6))
      .and(change(SpeedDate, :count).to(128))
    )
  end
end