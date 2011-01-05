module ProfilesHelper
	def favourites_link(category)
	  case category
		when "docs"
			link_to("Documents", params.merge(:page => 1, :toggle => "documents"), :class => 'favNavLinkSty')
		when "ques"
			link_to("Questions", params.merge(:page => 1, :toggle => "questions"), :class => 'favNavLinkSty')
		when "events"
			link_to("Events", params.merge(:page => 1, :toggle => "events"), :class => 'favNavLinkSty')
		when "all"
			link_to("Show All", params.merge(:page => 1, :toggle => "all"), :class => 'favNavLinkSty')
	   end
	end
end
