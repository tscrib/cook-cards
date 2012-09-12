module RecipesHelper
	DIRECTION_REGEX = /(ire)/
	INGREDIENT_REGEX = /(gredient)/
	
	# Given a Nokogiri page, and a regex, search all h tags 
	# and return the content it encloses
	def scrape_page( page, regex )
		@my_node=@content=nil

		# Find the node which should be the desired content
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

	# Given a Nokogiri page,return the title
	# Could be robust-ified
	def scrape_title( page )
		page.title.split( ' - ' )[0]
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
