# encoding: UTF-8
# == Schema Information
#
# Table name: recipes
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  ingredients :text
#  directions  :text
#  photo_url   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
include RecipesHelper

class Recipe < ActiveRecord::Base
	attr_accessible :directions, :ingredients, :photo_url, :title

	VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*‌​)?/ix

	validates :title, presence: true
	validates :directions, presence: true
	validates :photo_url, presence: true#, format: { with: VALID_URL_REGEX }

	# Use case insensitive search when querying names
	def self.search(search, page)
		if search
			# Although this query works, apparently it is not a paginated query and will load the entire database
			# @recipes=find(:all, conditions: ['title ILIKE ?', "%#{search}%"]).paginate(page: page)

			# Good query
			@recipes=Recipe.paginate(page: page, conditions: ['title ILIKE ?', "%#{search}%"])
		else
			@recipes=Recipe.paginate(page: page)
		end
		
	end

	def self.add_by_url( url )
		agent = Mechanize.new
		agent.get(url)

		@directions = scrape_page( agent.page, DIRECTION_REGEX )
		@ingredients = scrape_page( agent.page, INGREDIENT_REGEX )
		@title = scrape_title( agent.page )
		@photo_url = scrape_img( agent.page, @title )
		puts @photo_url

		if( @directions.blank? || @ingredients.blank? || @photo_url.blank? )
			return nil 
		else
			Recipe.create!( 
				title: @title, 
				directions: @directions,
				ingredients: @ingredients,
				photo_url: @photo_url)
		end
	end

end
