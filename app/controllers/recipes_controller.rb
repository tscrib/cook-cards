class RecipesController < ApplicationController
	before_filter :signed_in_user, only: [:new, :edit, :update, :destroy]
	before_filter :admin_user, only: [:edit, :update, :destroy]

	def index
		if signed_in?
			@user = current_user
		end
		@recipes = Recipe.search(params[:search], params[:page])
	end

	def new
		@recipe = Recipe.new
	end

	def create
		@recipe = Recipe.new(params[:recipe])
		if @recipe.save
			flash[:success] = "Your Recipe was Created!"
			redirect_to recipe_path(@recipe)
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
		# Before filters takes care of knowing who to allow
		@recipe = Recipe.find(params[:id])
	end

	def update
		# Get local instance
		@recipe = Recipe.find(params[:id])

		# Update object with entered values
		if @recipe.update_attributes(params[:recipe])
			flash[:success] = "Recipe updated"
			redirect_to @recipe
		else
			render 'edit'
		end
	end

	def destroy
		# Before filters takes care of knowing who to allow
		Recipe.find(params[:id]).destroy
		flash[:success] = "Recipe deleted."
		redirect_to recipes_url
	end

	def add_by_url
		# render "good work"
		url = params[:add_by_url]
		if uri?( url )
			
			if Recipe.add_by_url( url )
				flash[:success] = "Recipe Created!"
			else
				flash[:error] = "Recipe not found on page"
			end
		else
			flash[:error] = "Recipe URL incorrect"
		end
		redirect_to recipes_path
	end

	# private methods
	private

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
end
