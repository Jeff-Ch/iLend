class Borrower < ActiveRecord::Base
	has_many :lenders, through: :transactions
	has_secure_password

	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
	validates :first_name, :last_name, :email, :password, :purpose, :description, :money, presence: true
	validates :email, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
	validate :unique_email
	validates :password, length: {minimum: 6}
	validates :money, numericality: true

	def unique_email
		self.errors.add(:email, 'is already taken') if Lender.where(:email => self.email).exists?
	end
	
end
