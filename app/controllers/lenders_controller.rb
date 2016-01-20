class LendersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
		@lender = Lender.find(session[:lender_id])
		@total_lent = 0
		@lent_to = []
		Transaction.where(:lender_id => session[:lender_id]).each do |trans|
			@total_lent += trans.money
			@lent_to_one = trans.money
			@temp = [Borrower.find(trans.borrower_id), @lent_to_one]
			@lent_to.push(@temp)
		end
		@balance = @lender.money - @total_lent
		@borrowers = Borrower.all
	end

	def create
		@lender = Lender.new(lender_params)
		if @lender.valid?
			@lender.save
			session[:lender_id] = Lender.last.id
			session[:borrower_id] = 'not a borrower'
			redirect_to "/lenders"
		else
			flash[:error] = @lender.errors.full_messages
			redirect_to "/sessions/lender_register"
		end
	end

	def lend
	end

	def deposit_confirmation
		@amt = params[:amt];
	end

	private
	def lender_params
		params.require(:lender).permit(:first_name, :last_name, :email, :password, :password_confirmation, :money)
	end

end
