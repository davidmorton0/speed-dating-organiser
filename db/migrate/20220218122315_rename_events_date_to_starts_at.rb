class RenameEventsDateToStartsAt < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :date, :starts_at
  end
end
