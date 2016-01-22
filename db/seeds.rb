# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Lender.create(first_name: 'John', last_name: 'Doe', email: 'test@gmail.com', password: '123456', password_confirmation: '123456', money: 0)

History.create(lender_id: 1, money: 1000, source: "Direct Deposit", direction: "in")



Borrower.create(first_name: 'Jane', last_name: 'Doe', email: '1@g.com', password: '123456', password_confirmation: '123456')
Request.create(purpose: 'Television', description: "My old black and white doesn't cut it anymore", money: 400, money_raised: 200, borrower_id: 1)

Borrower.create(first_name: 'Jack', last_name: 'Sparrow', email: '2@g.com', password: '123456', password_confirmation: '123456')
Request.create(purpose: 'Treasure Map', description: "Found in an antique shop", money: 600, money_raised: 600, borrower_id: 2)

Borrower.create(first_name: 'Kobe', last_name: 'Bryant', email: '3@g.com', password: '123456', password_confirmation: '123456')
Request.create(purpose: 'Cellphone', description: "My old phone broke", money: 600, money_raised: 200, borrower_id: 3)

Transaction.create(lender_id: 1, request_id: 1, money: 200, paid_back: 0)
History.create(lender_id: 1, money: 200, source: "Loan  to Jane Doe", direction: "out")
Transaction.create(lender_id: 1, request_id: 3, money: 200, paid_back: 0)
History.create(lender_id: 1, money: 200, source: "Loan to Kobe Bryant", direction: "out")
Transaction.create(lender_id: 1, request_id: 2, money: 600, paid_back: 0)
History.create(lender_id: 1, money: 600, source: "Loan to Jack Sparrow", direction: "out")