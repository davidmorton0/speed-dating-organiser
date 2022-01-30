class AddMaxRoundsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :max_rounds, :integer
  end
end
