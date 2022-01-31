class AddNullFalseToEventsMaxRounds < ActiveRecord::Migration[7.0]
  def change
    change_column :events, :max_rounds, :integer, null: false
  end
end
