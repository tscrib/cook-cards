class RecipesController < ApplicationController
	before_filter :signed_in_user, only: [:new, :edit, :update, :destroy]


	def index
		if signed_in?
			@user = current_user
		end
		@recipes = Recipe.search(params[:search], params[:page])
	end

	def new
		
	end

	def create
		@recipe = User.new(params[:recipe])
		if @user.save
	      # Handle a successful save.
	    else
	      render 'new'
	    end
	end

	def show
		if signed_in?
			@user = current_user
		end
		@recipe = Recipe.find(params[:id])
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end
end
