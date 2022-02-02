class CreateOrganisations < ActiveRecord::Migration[7.0]
  def change
    create_table :organisations do |t|
      t.column :name, :string, limit: 128, null: false

      t.timestamps
    end
  end
end
