# frozen_string_literal: true

include FactoryBot::Syntax::Methods

class GenerateSeeds
  def call
    # Create 2 events with 5 male and 5 female daters and the same rep
    rep_1 = create(:rep)
    event = Event.create(title: "Drinks at a bar", date: DateTime.current + 3.days, rep: rep_1)
    create_list(:dater, 5, event: event, gender: 'female')
    create_list(:dater, 5, event: event, gender: 'male')

    event = Event.create(title: "Drinks at a pub", date: DateTime.current + 5.days, rep: rep_1)
    create_list(:dater, 5, event: event, gender: 'female')
    create_list(:dater, 5, event: event, gender: 'male')

    # Create an events with unbalanced numbers of daters for a different rep
    rep_2 = create(:rep)
    event = Event.create(title: "Drinks in a car park", date: DateTime.current + 3.days, rep: rep_2)
    create_list(:dater, 4, event: event, gender: 'female')
    create_list(:dater, 5, event: event, gender: 'male')

    event = Event.create(title: "Dance party", date: DateTime.current + 3.days, rep: rep_2)
    create_list(:dater, 7, event: event, gender: 'female')
    create_list(:dater, 5, event: event, gender: 'male')

    # Create event with matches
    event = Event.create(title: "Dating event with matches", date: DateTime.current, rep: rep_2)
    female_daters = create_list(:dater, 8, event: event, gender: 'female')
    male_daters = create_list(:dater, 8, event: event, gender: 'male')
    female_dater_ids = female_daters.map {|dater| dater.id }
    male_dater_ids = male_daters.map {|dater| dater.id }
    female_daters[0].update(matches: male_dater_ids.sample(4))
    female_daters[1].update(matches: male_dater_ids.sample(2))
    male_daters[0].update(matches: female_dater_ids.sample(2))
    male_daters[2].update(matches: female_dater_ids.sample(5))
    male_daters[4].update(matches: female_dater_ids.sample(2))

    # Create different users
    create(:admin)
    create(:user)
  end

end