class RecipesController < ApplicationController
	before_filter :signed_in_user


	def index
		@user = current_user
		@recipes = Recipe.paginate(page: params[:page])
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
		@user = current_user
		@recipe = Recipe.find(params[:id])
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end
end
