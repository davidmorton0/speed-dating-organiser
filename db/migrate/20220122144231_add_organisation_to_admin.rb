class AddOrganisationToAdmin < ActiveRecord::Migration[7.0]
  def change
    add_reference :admins, :organisation, index: true, null: false
  end
end
