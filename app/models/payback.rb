class Payback < ActiveRecord::Base
  belongs_to :borrower
  belongs_to :lender
  belongs_to :request
end
