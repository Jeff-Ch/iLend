# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Lender.create(first_name: 'John', last_name: 'Doe', email: 'test@gmail.com', password: '123456', password_confirmation: '123456', money: 0);

Borrower.create(first_name: 'Jane', last_name: 'Doe', email: '2@g.com', password: '123456', password_confirmation: '123456')
Request.create(purpose: 'Television', description: "I need to watch my shows", money: 300, money_raised: 0, borrower_id: 1)