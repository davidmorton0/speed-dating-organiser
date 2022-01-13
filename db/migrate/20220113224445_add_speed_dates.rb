class AddSpeedDates < ActiveRecord::Migration[7.0]
  def change
    create_table :speed_dates do |t|
      t.references :dater_1, as: :dater, foreign_key: true
      t.references :dater_2, as: :dater, foreign_key: true
      t.references :event, foreign_key: true
      t.integer :round

      t.timestamps
    end
  end
end
