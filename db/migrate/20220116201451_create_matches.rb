class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :matcher, foreign_key: { to_table: :daters }
      t.references :matchee, foreign_key: { to_table: :daters }

      t.timestamps
    end
  end
end
