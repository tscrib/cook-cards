# static pages controller inherits from application controller

class StaticPagesController < ApplicationController
  def home
  	if signed_in?
      # @micropost  = current_user.microposts.build
      # @feed_items = current_user.feed.paginate(page: params[:page])
      @my_recipes = current_user.added_recipes
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
