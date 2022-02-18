class ChangeNameToFirstNameAndSurnameForDaters < ActiveRecord::Migration[7.0]
  def change
    rename_column :daters, :name, :first_name
    add_column :daters, :surname, :string, limit: 128
  end
end
