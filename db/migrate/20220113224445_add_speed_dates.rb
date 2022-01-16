class AddSpeedDates < ActiveRecord::Migration[7.0]
  def change
    create_table :speed_dates do |t|
      t.references :dater1, foreign_key: { to_table: 'daters' }
      t.references :dater2, foreign_key: { to_table: 'daters' }
      t.references :event, foreign_key: true
      t.integer :round

      t.timestamps
    end
  end
end
