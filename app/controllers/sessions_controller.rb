class SessionsController < ApplicationController

	def index
	end

	def login_attempt
		@borrower = Borrower.where(:email => params[:user][:email]).first
		@lender = Lender.where(:email => params[:user][:email]).first
		if @borrower && @borrower.authenticate(params[:user][:password])
			session[:borrower_id] = @borrower.id
			session[:lender_id] = 'not a lender'
			redirect_to "/borrowers"
		elsif @lender && @lender.authenticate(params[:user][:password])
			session[:lender_id] = @lender.id
			session[:borrower_id] = 'not a borrower'
			redirect_to "/lenders"
		else
			flash[:error] = []
			flash[:error].push("Invalid Login, Try Again")
			redirect_to "/sessions/login"
		end
	end

	def logout
	end
end
