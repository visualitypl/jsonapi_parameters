class CreateScissors < ActiveRecord::Migration[6.0]
  def change
    create_table :scissors do |t|
      t.boolean :sharp
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
