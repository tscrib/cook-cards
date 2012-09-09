module ApplicationHelper

	# Returns the full title on a per-page basis.
 def full_title(page_title)

   base_title = "Cook Cards"

   if page_title.empty?
      		base_title			# Implicit return
       else
      		"#{base_title} | #{page_title}"		# String interpolation
       end
     end

     # 
     # params expected:
     # :obj
     # :method
     def btn_icon( icon, param={} )
      if param.empty?
        button_tag nil, class: "btn btn-mini", id: icon do
          content_tag(:i, nil, class: icon)
        end
      else

        link_to param[:obj], class: "btn btn-mini", method: param[:method], id: icon do
          content_tag(:i, nil, class: icon)
        end
      end
      
    end
  end
