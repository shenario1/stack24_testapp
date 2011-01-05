class SearchesController < ApplicationController
  def index
    begin
		@searchterm = params[:searchterm]
		@toggle = params[:toggle] || "all"
		page = params[:page]
        @title = "Search Results"
        UserHistory.create!(:page_url => request.url, :profile_id => session[:user_id])
        @searchresults = Search.search(@searchterm)
		@searchresults[:all] = @searchresults.values_at(:document_results,:question_results,:event_results,:profile_results).flatten.compact
		case @toggle
			when "documents"
				if !@searchresults[:document_results].nil?
					@searchresults[:document_results] = @searchresults[:document_results].paginate(:per_page=>@per_page,:page => page)
				end
			when "questions"
				if !@searchresults[:question_results].nil?
					@searchresults[:question_results] = @searchresults[:question_results].paginate(:per_page=>@per_page,:page => page)
				end
			when "events"
				if !@searchresults[:event_results].nil?
					@searchresults[:event_results] = @searchresults[:event_results].paginate(:per_page=>@per_page,:page => page)
				end
			when "users"
				if !@searchresults[:profile_results].nil?
					@searchresults[:profile_results] = @searchresults[:profile_results].paginate(:per_page=>@per_page,:page => page)
				end
			when "all"
				if !@searchresults[:all].nil?
					@searchresults[:all] = @searchresults[:all].paginate(:per_page=>@per_page,:page => page)
				end
		end
    rescue
        @title = "Search"
        @searchresults = nil
        flash[:notice] = "You have a entered a blank search term"
    end
  end
end
