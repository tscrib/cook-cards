class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	def create
		@recipe = Recipe.find(params[:relationship][:recipe_id])
		current_user.add!(@recipe)
		redirect_to recipes_path
	end

	def destroy
		@recipe = Relationship.find(params[:id])
		current_user.remove!(@recipe)
		redirect_to recipes_path
	end
end
