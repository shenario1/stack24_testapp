# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    base_title = "Clari5"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{h(@title)}"
    end
  end
  
  def per_page
	@per_page = 20
  end

  def javascript(*args)
	content_for(:head) { javascript_include_tag(*args) }
  end
  
  def index_link(category)
	  case category
		when "recent"
			link_to("Most Recent", params.merge(:page => 1, :toggle => category), :class => 'mostRecentPop')
		when "popular"
			link_to("Most Popular", params.merge(:page => 1, :toggle => category), :class => 'mostRecentPop')
	   end
  end
  
  def medal_tag(profile_id)
	@profile = Profile.find_by_id(profile_id)
	case @profile.points
		when 20..200
			image_tag('medal1.png')
		when 201..600
			image_tag('medal2.png')
		when 601..1200
			image_tag('medal2_5.png')
		when 1201..1800
			image_tag('medal3.png')
		when 1801..2400
			image_tag('medal3_5.png')
		when 2401..3200
			image_tag('medal4.png')
		when 3201..4000
			image_tag('medal4_5.png')
		when 4001..6000
			image_tag('medal5.png')
		when 6001..7000
			image_tag('star1.png')
		when 7001..8000
			image_tag('star2.png')
		when 8001..9000
			image_tag('star3.png')
		when 9001..10000
			image_tag('star4.png')
		else
			if @profile.points >= 10001
				image_tag('star5.png')
			else
				image_tag('medal0.png')
			end
	end
  end
end
