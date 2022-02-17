class AddDaterAndDateeToSpeedDates < ActiveRecord::Migration[7.0]
  def change
    add_reference :speed_dates, :dater, index: true
    add_reference :speed_dates, :datee, index: true
  end
end
