class ChangeSurnameToNullFalse < ActiveRecord::Migration[7.0]
  def change
    change_column :daters, :surname, :string, limit: 128, null: false
  end
end
