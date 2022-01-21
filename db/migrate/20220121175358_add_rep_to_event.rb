class AddRepToEvent < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :rep, index: true
  end
end
