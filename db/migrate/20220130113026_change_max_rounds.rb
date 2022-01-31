class ChangeMaxRounds < ActiveRecord::Migration[7.0]
  def up
    Event.where(max_rounds: nil).update_all(max_rounds: 10)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
