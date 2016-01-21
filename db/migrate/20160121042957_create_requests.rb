class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :purpose
      t.string :description
      t.integer :money
      t.integer :money_raised
      t.references :borrower, index: true

      t.timestamps
    end
  end
end
