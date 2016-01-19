class BorrowersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
	end

	def create
		@borrower = Borrower.new(borrower_params)
		if @borrower.valid?
			@borrower.save
			session[:borrower_id] = Borrower.last.id
			session[:lender_id] = 'not a lender'
			redirect_to "/borrowers"
		else
			flash[:error] = @borrower.errors.full_messages
			redirect_to "/sessions/borrower_register"
		end
	end

	private
	def borrower_params
		params.require(:borrower).permit(:first_name, :last_name, :email, :password, :purpose, :description, :money, :money_raised)
	end
end
