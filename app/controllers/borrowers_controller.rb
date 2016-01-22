class BorrowersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
		@borrower = Borrower.find(session[:borrower_id])
		if @borrower.status
			redirect_to "/borrowers/complete"
		else
			@request = Request.where(:borrower_id => session[:borrower_id]).last
			@total_raised = 0
			@lent_from = []
			Transaction.where(:request_id => @request.id).each do |trans|
				@total_raised += trans.money
				@from_one = trans.money
				@temp = [Lender.find(trans.lender_id), @from_one]
				@lent_from.push(@temp)
			end
			if @total_raised != 0
				@progress = @total_raised * 200 / @request.money 
			else
				@progress = 0
			end
		end
	end

	def create
		@borrower = Borrower.new(borrower_params)
		if @borrower.valid?
			@request = Request.new(request_params)
			if @request.valid?
				if @request.money % 25 != 0
					flash[:error] = ["Money is not a multiple of 25"]
					redirect_to "/sessions/borrower_register"
				else
					@borrower.save
					session[:borrower_id] = Borrower.last.id
					session[:lender_id] = 'not a lender'
					@id = Borrower.last.id
					@request.attributes = {:borrower_id => @id}
					@request.save
					session[:request_id] = Request.last.id
					redirect_to "/borrowers"
				end
			else
				flash[:error] = @request.errors.full_messages
				redirect_to "/sessions/borrower_register"
			end
		else
			flash[:error] = @borrower.errors.full_messages
			redirect_to "/sessions/borrower_register"
		end
		
	end


	def complete
		@borrower = Borrower.find(session[:borrower_id])
		@borrower.attributes = {:status => true}
		@borrower.save(:validate => false)
		@request = Request.where(:borrower_id => session[:borrower_id]).last
		@total_raised = 0
		@lent_from = []
		Transaction.where(:request_id => @request.id).each do |trans|
			@total_raised += trans.money
			@from_one = trans.money
			@temp = [Lender.find(trans.lender_id), @from_one, trans.request_id, trans.paid_back]
			@lent_from.push(@temp)
		end
		@paybacks = Payback.joins(:lender).where(:request_id => Request.where(:borrower_id => session[:borrower_id]).last)
	end

	def payback_confirmation
		if params[:amount].to_i > params[:balance].to_i
			flash[:error] = ["Overpayment, Try Again"]
			redirect_to "/borrowers/complete"
		else
			@amt = params[:amount].to_i * 100
			@email = Borrower.find(session[:borrower_id]).email
			@name = Lender.find(params[:lender_id]).first_name + " " + Lender.find(params[:lender_id]).last_name
			@info = params
		end
	end

	def payback
		@payback = Transaction.where(:lender_id => params[:lender_id]).where(:request_id=> params[:id]).first
		if @payback.paid_back != 0
			@total = @payback.paid_back.to_i + params[:amount].to_i
			Transaction.update(@payback.id, :paid_back => @total)
		else
			Transaction.update(@payback.id, :paid_back => params[:amount])
		end
		History.create(:lender_id => params[:lender_id], :money => params[:amount], :source => "Payment from "+ Borrower.find(session[:borrower_id]).first_name + " "+Borrower.find(session[:borrower_id]).last_name, :direction => "in")
		@lender = Lender.find(params[:lender_id])
		@total = @lender.money + params[:amount].to_i
		@lender.attributes = {:money => @total}
		@lender.save(:validate => false)
		redirect_to "/borrowers/complete"
	end

	private
	def borrower_params
		params.require(:borrower).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

	def request_params
		params.require(:request).permit(:purpose, :description, :money, :money_raised)
	end
end
