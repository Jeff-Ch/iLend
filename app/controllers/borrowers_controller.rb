class BorrowersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
	end

	def create
	end
end
