class Request < ActiveRecord::Base
  belongs_to :borrower

  validates :purpose, :description, :money, :money_raised, presence: true
  validates :money, numericality: true
end
