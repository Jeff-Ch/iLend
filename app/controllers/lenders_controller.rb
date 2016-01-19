class LendersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
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

	private
	def lender_params
		params.require(:lender).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

end
