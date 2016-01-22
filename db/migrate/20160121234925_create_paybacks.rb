class CreatePaybacks < ActiveRecord::Migration
  def change
    create_table :paybacks do |t|
      t.references :borrower, index: true
      t.references :lender, index: true
      t.integer :money
      t.integer :money_lent
      t.references :request, index: true

      t.timestamps
    end
  end
end
