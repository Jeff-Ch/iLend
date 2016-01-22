class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :lender, index: true
      t.references :request, index: true
      t.integer :money
      t.integer :paid_back

      t.timestamps
    end
  end
end
