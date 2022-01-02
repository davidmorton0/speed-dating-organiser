class AddEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.column :title, :string, :limit => 128, :null => false
      t.column :date, :datetime, :null => false
      t.timestamps
    end
  end
end
