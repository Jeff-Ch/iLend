class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :lender, index: true
      t.integer :money
      t.string :source
      t.string :direction

      t.timestamps
    end
  end
end
