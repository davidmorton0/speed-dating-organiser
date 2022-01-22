# frozen_string_literal: true

class AddEvent
  def initialize(title:, date:, rep_id:, organisation_id:)
    @title = title
    @date = date
    @rep_id = rep_id
    @organisation_id = organisation_id
  end

  def call
    organisation = Organisation.find(organisation_id)
    rep = Rep.find(rep_id)
    raise 'Selected rep does not belong to this organisation' unless organisation == rep.organisation

    Event.create(title: title, date: date, rep: rep, organisation: organisation)
  end

  private

  attr_accessor :title, :date, :rep_id, :organisation_id
end