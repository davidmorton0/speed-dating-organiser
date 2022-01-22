class AddOrganisationToEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :organisation, index: true, null: false
  end
end
