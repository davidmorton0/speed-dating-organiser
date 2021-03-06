# frozen_string_literal: true

include FactoryBot::Syntax::Methods

class GenerateSeeds
  def call
    DatabaseCleaner.clean_with(:truncation)
    
    # Create an organisation
    organisation = create(:organisation)
    create(:admin, organisation: organisation)
    # Create 2 events with 5 male and 5 female daters and the same rep
    rep_1 = create(:rep, organisation: organisation)
    event = Event.create(title: 'Drinks at a bar', location: 'Piano Bar, Old Street, London', starts_at: DateTime.current + 3.days, rep: rep_1,
                         organisation: organisation, max_rounds: Constants::MAX_ROUNDS)
    create_list(:dater, 5, :female, event: event)
    create_list(:dater, 5, :male, event: event)

    event = Event.create(title: 'Drinks at a pub', location: 'Coach and Horses, Main Street, Worthing', starts_at: DateTime.current + 5.days, rep: rep_1,
                         organisation: organisation, max_rounds: 4)
    create_list(:dater, 5, :female, event: event)
    create_list(:dater, 5, :male, event: event)

    # Create a event for a different rep
    rep_2 = create(:rep, organisation: organisation)
    event = Event.create(title: 'Drinks in a car park', location: 'Tesco, Watford', starts_at: DateTime.current + 3.days, rep: rep_2,
                         organisation: organisation, max_rounds: Constants::MAX_ROUNDS)
    create_list(:dater, 4, :female, event: event)
    create_list(:dater, 5, :male, event: event)

    # Create a event with no rep
    event = Event.create(title: 'Dance party', location: 'Rhythm Room, Broad Street, Manchester', starts_at: DateTime.current + 3.days, rep: nil, organisation: organisation,
                         max_rounds: Constants::MAX_ROUNDS)
    create_list(:dater, 7, :female, event: event)
    create_list(:dater, 5, :male, event: event)

    # Create event with matches and speed dates
    event = Event.create(title: 'Dating event with matches', location: 'The Crown, Edgware Road, London', starts_at: DateTime.current, rep: rep_2,
                         organisation: organisation, max_rounds: Constants::MAX_ROUNDS)
    female_daters = create_list(:dater, 8, :female, event: event)
    male_daters = create_list(:dater, 8, :male, event: event)
    female_dater_ids = female_daters.map { |dater| dater.id }
    male_dater_ids = male_daters.map { |dater| dater.id }
    female_daters[0].update(matches: male_dater_ids.sample(4))
    female_daters[1].update(matches: male_dater_ids.sample(2))
    male_daters[0].update(matches: female_dater_ids.sample(2))
    male_daters[2].update(matches: female_dater_ids.sample(5))
    male_daters[4].update(matches: female_dater_ids.sample(2))
    CreateDatingSchedule.new(event: event).call

    # create event for different organisation
    organisation_2 = create(:organisation)
    create(:admin, organisation: organisation_2)
    rep_3 = create(:rep, organisation: organisation_2)
    event = Event.create(title: 'Drinks at another bar', location: 'The Swan, New Street, Matlock', starts_at: DateTime.current + 2.days, rep: rep_3,
                         organisation: organisation_2, max_rounds: Constants::MAX_ROUNDS)
    create_list(:dater, 4, :female, event: event)
    create_list(:dater, 4, :male, event: event)
  end
end
