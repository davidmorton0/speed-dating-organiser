class DestroySpeedDateAppointments < ActiveRecord::Migration[7.0]
  def change
    drop_table :speed_date_appointments
  end
end
