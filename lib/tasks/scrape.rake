desc "Scrape websites for recipes"
task :scrape => :environment do
	include RecipesHelper

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

desc "For testing algorithms"
task :tim => :environment do
	include RecipesHelper

	agent = Mechanize.new
	# agent.get"http://www.vegetariantimes.com/recipe/poached-eggs-over-asparagus/"
	# agent.get("http://www.marthastewart.com/911343/thick-burger?czone=food/best-grilling-recipes/grilling-recipes&center=276943&gallery=275667&slide=911343")
	# agent.get("http://allrecipes.com/Recipe/Cheese-Ravioli-with-Fresh-Tomato-and-Artichoke-Sauce/Detail.aspx")
	
	agent.get("http://www.marthastewart.com/314910/whole-wheat-spaghetti-with-gorgonzola-an?center=852566&gallery=275563&slide=259314")

	title = scrape_title( agent.page )
	title.slice!(title.rindex("|")..title.length) unless title.rindex("|").nil?

	# puts title
	# puts title.split
	# puts title.split(/ |-/).reject{|s| s=~/(\|)|(with)|(recipe)|( [a-z]{1,3} )|\d/}

	title_words = title.downcase.strip.split(/ |-/).reject{|s| s=~/(\|)|(with)|(recipe)|( [a-z]{1,3} )|\d/}
	# title = title.strip.slice(1..5).downcase
	# puts title_words
	@img_url=nil
	@desired_nodes=[]

	agent.page.search("img").each do |node|
		unless node.nil?
			unless node.attr("title").nil?
				# puts "1" if node.attr("title").downcase =~ /(#{title})/
				 # puts node.attr("title")

				# if node.attr("title").downcase =~ /(#{title})/
				# 	@desired_nodes.push(node)
				# 	break
				# end

				title_words.each do |word|
					if node.attr("title").downcase =~ /(#{word})/
						@desired_nodes.push(node)
						break
					end
				end
			end

			unless node.attr("src").nil?
				# puts "2" if node.attr("src").split(/\//).last.gsub("-", " ").gsub("_", " ").downcase =~ /(#{title})/
				 # puts node.attr("src").split(/\//).last.gsub("-", " ").gsub("_", " ").downcase
				# if node.attr("src").split(/\//).last.gsub("-", " ").gsub("_", " ").downcase =~ /(#{title})/
				# 	@desired_nodes.push(node)
				# 	break
				# end

				title_words.each do |word|
					if node.attr("src").split(/\//).last.downcase =~ /(#{word})/
						@desired_nodes.push(node)
						break
					end
				end
			end
		end
	end

	# Ensure matches are actual files
	# @desired_nodes.each do |node|
	# 	@desired_nodes.pop(node) if node.attr("src") =~ /(.*\..*)/
	# end

	# puts @desired_nodes.class
	# puts @desired_nodes.last

	 # puts uri?(@desired_node.attr("src"))
	# puts "hello"				
	@img_url = @desired_nodes.first.attr("src")
	@img_url = ( "http://" << agent.page.canonical_uri.host << @img_url ) unless uri?( @img_url )

	puts @img_url
end
