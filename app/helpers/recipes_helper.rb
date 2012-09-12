module RecipesHelper
	DIRECTION_REGEX = /(ire)/
	INGREDIENT_REGEX = /(gredient)/

	# Given a Nokogiri page, and a regex, search all h tags 
	# and return the content it encloses
	def scrape_page( page, regex )
		@my_node=@content=nil

		# Find the node which should be the desired content, title tags only
		['h1', 'h2', 'h3', 'h4', 'h5'].each do |h|
			page.search(h).children.each do |node|
				@my_node=node if node.inner_text =~ regex
			end
			break unless @my_node.nil?
		end

		# Handle the case where nothing was found
		unless @my_node.nil?
			# Searched-for content will be the next 
			# parent node which is not blank
			@content = @my_node.parent.next
			@content = @content.next until !@content.blank?
		end

		if !@content.nil? 
			return @content.inner_text 
		else
			nil
		end
	end

	# Given a Nokogiri page, return the title
	# Could be robust-ified
	def scrape_title( page )
		page.title.split( ' - ' )[0]
	end

	# Given a Nokogiri page, and likely title, return the image
	# Searches both 'title' and 'src' tags
	def scrape_img( page, title )
		@desired_node=@img_url=nil

		title = title.strip.slice(1..5).downcase

		# for all 'img' tags, determine if it's title tag is 
		# similar to the recipe title, or determine if the image filename
		# itself is similar to the title of the recipe. If so, hold on to the node
		page.search("img").each do |node|
			unless node.attr("title").nil?
				if node.attr("title").downcase =~ /(#{title})/
					@desired_node=node
					break
				end
			end

			unless node.attr("src").nil?
				if node.attr("src").split(/\//).last.gsub("-", " ").gsub("_", " ").downcase =~ /(#{title})/
					@desired_node=node
					break
				end
			end
		end
			
		# Some sites strip out the host; add it, if necessary
		@img_url = @desired_node.attr("src")
		@img_url = ( "http:///" << page.canonical_uri.host << @img_url ) unless uri?( @img_url )
		puts @img_url
		return @img_url
	end

	# Performs a check on the input string to see if it is a valid URI
	def uri?(string)
		uri = URI.parse(string)
		%w( http https ).include?(uri.scheme)
	rescue URI::BadURIError
		false
	rescue URI::InvalidURIError
		false
	end
end
