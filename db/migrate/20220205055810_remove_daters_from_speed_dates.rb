class RemoveDatersFromSpeedDates < ActiveRecord::Migration[7.0]
  def change
    remove_column :speed_dates, :dater1_id
    remove_column :speed_dates, :dater2_id
  end
end
