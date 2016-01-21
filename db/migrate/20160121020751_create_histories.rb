class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :lender, index: true
      t.integer :money

      t.timestamps
    end
  end
end
