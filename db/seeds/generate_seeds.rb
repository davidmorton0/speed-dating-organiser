# frozen_string_literal: true

include FactoryBot::Syntax::Methods

class GenerateSeeds
  def call    
    # Create 10 events
    10.times do |n|
      event = Event.create(title: "Event #{n}", date: DateTime.current + n.days)
      (5..20).to_a.sample.times { create(:dater, event: event) }
    end
  end

end