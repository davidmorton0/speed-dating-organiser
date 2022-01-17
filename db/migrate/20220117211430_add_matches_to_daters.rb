class AddMatchesToDaters < ActiveRecord::Migration[7.0]
  def change
    add_column :daters, :matches, :text, array: true, default: []
  end
end
