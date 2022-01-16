# frozen_string_literal: true

include FactoryBot::Syntax::Methods

class GenerateSeeds
  def call    
    # Create 10 events
    10.times do |n|
      event = Event.create(title: "Event #{n}", date: DateTime.current + n.days)
      number_of_daters = (5..20).to_a.sample
      create_list(:dater, number_of_daters, event: event)
    end

    # Create event with matches
    event = Event.create(title: "Event with matches", date: DateTime.current + 5.days)
    female_daters = create_list(:dater, 5, event: event, gender: 'female')
    male_daters = create_list(:dater, 5, event: event, gender: 'male')
    create(:match, matcher: female_daters[0], matchee: male_daters[0])
    create(:match, matcher: female_daters[0], matchee: male_daters[2])
    create(:match, matcher: female_daters[0], matchee: male_daters[3])
    create(:match, matcher: female_daters[1], matchee: male_daters[2])
    create(:match, matcher: male_daters[0], matchee: female_daters[0])
    create(:match, matcher: male_daters[2], matchee: female_daters[0])
    create(:match, matcher: male_daters[4], matchee: female_daters[3])
  end

end