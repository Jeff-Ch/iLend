class LendersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
		@lender = Lender.find(session[:lender_id])
		@lent_to = []
		@paid_back =[]
		Transaction.where(:lender_id => session[:lender_id]).each do |trans|
			@lent_to_one = trans.money
			@temp = [Request.joins(:borrower).find(trans.request_id), @lent_to_one]
			if trans.money.to_i == trans.paid_back.to_i
				@paid_back.push(@temp)
			else
				@lent_to.push(@temp)
			end
		end
		@requests = Request.joins(:borrower).where(:money > :money_raised)
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
		if params[:amount] == nil
			flash[:error] = ["No Amount Detected"]
			redirect_to "/lenders"
		elsif Lender.find(session[:lender_id]).money < params[:amount].to_f
			flash[:error] = ["Insufficient Funds"]
			redirect_to "/lenders"
		elsif params[:amount].to_f > params[:money_left].to_f
			flash[:error] = ["Overpayment"]
			redirect_to "/lenders"
		else
			@trans = Transaction.where(:lender_id => session[:lender_id]).where(:request_id=> params[:id]).first
			if @trans
				@total = params[:amount].to_f + @trans.money
				Transaction.update(@trans.id, :money => @total)
				@amount_raised = Request.find(params[:id]).money_raised
				if @amount_raised == 0
					@total = params[:amount]
				else
					@total = @amount_raised + params[:amount].to_i
				end
				@request = Request.find(params[:id])
				@request.attributes = {:money_raised => @total}
				@request.save(:validate => false)
			else
				Transaction.create(:lender_id => session[:lender_id], :request_id => params[:id], :money => params[:amount], :paid_back => 0)
				@amount_raised = Request.find(params[:id]).money_raised
				if @amount_raised == 0
					@total = params[:amount]

				else
					@total = @amount_raised + params[:amount].to_i
				end
				@request = Request.find(params[:id])
				@request.attributes = {:money_raised => @total}
				@request.save(:validate => false)
			end
			@borrower = Request.joins(:borrower).find(params[:id]).borrower.first_name + " " + Request.joins(:borrower).find(params[:id]).borrower.last_name
			History.create(:lender_id => session[:lender_id], :money => params[:amount], :source => "Loan to "+ @borrower, :direction => "out")
			@lender = Lender.find(session[:lender_id])
			if @lender.money > 0
				@total = @lender.money - params[:amount].to_i
			else
				@total = params[:amount]
			end
			@lender.attributes = {:money => @total}
			@lender.save(:validate => false)
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
		History.create(:lender_id => session[:lender_id], :money => params[:amt].to_i/100, :source => "Direct Deposit", :direction => "in")
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
