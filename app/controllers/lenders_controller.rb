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
		if params[:balance].to_f < params[:amount].to_f
			flash[:error] = ["Insufficient Funds"]
			redirect_to "/lenders"
		else
			@trans = Transaction.where(:lender_id => session[:lender_id]).where(:borrower_id => params[:id]).first
			if @trans
				
				@total = params[:amount].to_f + @trans.money
				Transaction.update(@trans.id, :money => @total)
				@amount_raised = Borrower.find(params[:id]).money_raised
				if @amount_raised == 0
					@total = params[:amount]
				else
					@total = @amount_raised + params[:amount].to_i
				end
				@borrower = Borrower.find(params[:id])
				@borrower.attributes = {:money_raised => @total}
				@borrower.save(:validate => false)
			else
				
				Transaction.create(:lender_id => session[:lender_id], :borrower_id => params[:id], :money => params[:amount])
				@amount_raised = Borrower.find(params[:id]).money_raised
				if @amount_raised == 0
					@total = params[:amount]

				else
					@total = @amount_raised + params[:amount].to_i
				end
				@borrower = Borrower.find(params[:id])
				@borrower.attributes = {:money_raised => @total}
				@borrower.save(:validate => false)
			end
			redirect_to "/lenders"
		end
	end

	def deposit_confirmation
		@amt = params[:amt].to_i * 100
		@email = Lender.find(session[:lender_id]).email
	end

	def deposited
		@lender = Lender.find(session[:lender_id])
		if @lender.money == 0
			@lender.attributes = {:money => params[:amt].to_i/100}
		else
			@amt = @lender.money + params[:amt].to_i/100
			@lender.attributes = {:money => @amt}
		end
		@lender.save(:validate => false)
		History.create(:lender_id => session[:lender_id], :money => params[:amt].to_i/100)
		redirect_to "/lenders"
	end

	def history
		@deposits = History.where(:lender_id => session[:lender_id])
	end

	private
	def lender_params
		params.require(:lender).permit(:first_name, :last_name, :email, :password, :password_confirmation, :money)
	end

end
