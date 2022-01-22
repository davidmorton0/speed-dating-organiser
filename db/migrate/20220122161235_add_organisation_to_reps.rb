class AddOrganisationToReps < ActiveRecord::Migration[7.0]
  def change
    add_reference :reps, :organisation, index: true, null: false
  end
end
