require "~/rails_projects/cook-cards/app/helpers/recipes_helper"
include RecipesHelper

desc "Scrape websites for recipes"
task :scrape => :environment do

	agent = Mechanize.new
	# agent.get("http://www.marthastewart.com/911343/thick-burger?czone=food/best-grilling-recipes/grilling-recipes&center=276943&gallery=275667&slide=911343")
	# agent.get("http://www.marthastewart.com/food")
	agent.get"http://www.vegetariantimes.com/recipe/poached-eggs-over-asparagus/"

	@directions = scrape_page( agent.page, DIRECTION_REGEX )
	@ingredients = scrape_page( agent.page, INGREDIENT_REGEX )
	@title = scrape_title( agent.page )
	
	puts "dir"
	puts @directions
	p @directions.nil?
	puts @ingredients
	puts @title

	Recipe.create!( 
		title: @title, 
		directions: @directions,
		ingredients: @ingredients,
		photo_url: "http://www.marthastewart.com/sites/files/marthastewart.com/imagecache/img_l/ecl/msliving-hires/2012/08_august/in_house_cmyk/burgers/thick-burger-mld108880_vert.jpg")



end

task :tim => :environment do
	agent = Mechanize.new
	# agent.get"http://www.vegetariantimes.com/recipe/poached-eggs-over-asparagus/"
	agent.get("http://www.marthastewart.com/911343/thick-burger?czone=food/best-grilling-recipes/grilling-recipes&center=276943&gallery=275667&slide=911343")
	# agent.get("http://allrecipes.com/Recipe/Cheese-Ravioli-with-Fresh-Tomato-and-Artichoke-Sauce/Detail.aspx")

	title = scrape_title( agent.page ).strip.slice(1..5).downcase
	# puts title
	@desired_node=@img_url=nil

	agent.page.search("img").each do |node|

		unless node.attr("title").nil?
			# puts "1" if node.attr("title").downcase =~ /(#{title})/
			# puts node.attr("title")
			if node.attr("title").downcase =~ /(#{title})/
				@desired_node=node
				break
			end
		end

		unless node.attr("src").nil?
			# puts "2" if node.attr("src").split(/\//).last.gsub("-", " ").gsub("_", " ").downcase =~ /(#{title})/
			# puts node.attr("src").split(/\//).last.gsub("-", " ").gsub("_", " ").downcase
			if node.attr("src").split(/\//).last.gsub("-", " ").gsub("_", " ").downcase =~ /(#{title})/
				@desired_node=node
				break
			end
		end
	end

	# puts uri?(@desired_node.attr("src"))
	# puts "hello"				
	@img_url = @desired_node.attr("src")
	@img_url = ( agent.page.canonical_uri.host << @img_url ) unless uri?( @img_url )

	puts @img_url
end
