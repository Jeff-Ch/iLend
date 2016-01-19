# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160118194202) do

  create_table "borrowers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "purpose"
    t.string   "description"
    t.integer  "money"
    t.integer  "money_raised"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lenders", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "lender_id"
    t.integer  "borrower_id"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["borrower_id"], name: "index_transactions_on_borrower_id"
  add_index "transactions", ["lender_id"], name: "index_transactions_on_lender_id"

end
