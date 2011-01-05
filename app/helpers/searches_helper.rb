module SearchesHelper
	def search_link(category,searchterm)
	  case category
		when "docs"
			link_to("Documents", params.merge(:searchterm => searchterm, :page => 1, :toggle => "documents"), :class => 'searchNavLinkSty')
		when "ques"
			link_to("Questions", params.merge(:searchterm => searchterm, :page => 1, :toggle => "questions"), :class => 'searchNavLinkSty')
		when "events"
			link_to("Events", params.merge(:searchterm => searchterm, :page => 1, :toggle => "events"), :class => 'searchNavLinkSty')
		when "users"
			link_to("Users", params.merge(:searchterm => searchterm, :page => 1, :toggle => "users"), :class => 'searchNavLinkSty')
		when "all"
			link_to("Show All", params.merge(:searchterm => searchterm, :page => 1, :toggle => "all"), :class => 'searchNavLinkSty')
	   end
	end
end
