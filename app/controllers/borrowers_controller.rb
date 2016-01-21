class BorrowersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
		@borrower = Borrower.find(session[:borrower_id])
		@total_raised = 0
		@lent_from = []
		Transaction.where(:borrower_id => session[:borrower_id]).each do |trans|
			@total_raised += trans.money
			@from_one = trans.money
			@temp = [Lender.find(trans.lender_id), @from_one]
			@lent_from.push(@temp)
		end
		if @total_raised != 0
			puts @total_raised
			@progress = @total_raised / @borrower.money * 200
		else
			@progress = 0
		end
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
