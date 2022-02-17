class CreateSpeedDateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :speed_date_appointments do |t|
      t.references :dater
      t.references :speed_date

      t.timestamps
    end
  end
end
