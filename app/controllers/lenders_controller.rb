class LendersController < ApplicationController
	before_action :require_login, except: [:create, :index]

	def index
	end

	def create
	end

	def lend
	end

end
