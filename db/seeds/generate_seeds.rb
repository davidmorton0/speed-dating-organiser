# frozen_string_literal: true

class GenerateSeeds
  def call    
    # Create 10 events
    10.times do |n|
      Event.create(title: "Event #{n + 1}", date: DateTime.current + n.days)
    end
  end

end