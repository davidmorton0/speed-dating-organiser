class CreateDaters < ActiveRecord::Migration[7.0]
  def change
    create_table :daters do |t|
      t.column :name, :string, :limit => 128, :null => false
      t.column :email, :string, :limit => 128, :null => false
      t.column :phone_number, :string, :limit => 128, :null => false
      t.column :gender, :string, :limit => 128, :null => false
      t.references :event

      t.timestamps
    end
  end
end
