class EventsController < ApplicationController
before_filter :only =>[:edit,:destroy] do |controller| 
	controller.send(:object_correct_user, "Event")
end
before_filter :only =>[:remove_comment] do |controller| 
	controller.send(:object_correct_user, "CommentEvent")
end
  def new
    if !session[:user_id].nil?
      @event = Event.new
      @event.profile_id = session[:user_id]
	  @year = Time.zone.now.year.to_i
	  @month = Time.zone.now.month.to_i
	  @day = Time.zone.now.day.to_i
	  @event.event_date = (params[:date] || Date.civil(@year,@month,@day))
    end
    @title = "Create Event"
  end

  def edit
    begin
      @event = Event.find(params[:id])
	  @title = "Editing #{@event.event_name}"
	rescue
      flash.now[:error] = "Cannot edit the event"
      redirect_to events_path
    end
  end

  def index
   begin
	 page = params[:page]
	 toggle = params[:toggle] || "recent"
     case toggle
		when "recent"
			order = 'created_at DESC'
		when "popular"
			order = 'viewcount DESC'
	 end
	 if (params.keys[2].to_s == "profile_id")
		if !session[:user_id].nil?
			@events = Event.paginate :per_page => @per_page, :page => page,
								     :conditions => ["profile_id = ? ",session[:user_id]],
									 :order => order
			@title = "My Events"
		end
	 else
		 @events = Event.paginate :per_page => @per_page, :page => page,
								  :order => order
		 @title = "Events"
	 end
   rescue
     redirect_to profile_path(session[:user_id])
   end
 end
	
  def show
    @event = Event.find(params[:id])
    UserHistory.create!(:page_url => request.url, :profile_id => session[:user_id])
    @title = "#{@event.event_name}"
	
	if !session[:user_id].nil?
        @owner = Event.is_owner(params[:id],session[:user_id])
        @fav_status = FavouriteEvents.fav_status(@event.id,session[:user_id])
    else
        @owner = Event.is_owner(params[:id],nil)
        @fav_status = 0
    end
	if Event.change_viewcount(params[:id]) == -1
        flash[:notice] = 'Error while increasing the view count'
    end
  end
  
  def create
    begin
      if !session[:user_id].nil?
        @event = Event.new(params[:event])
		if @event.save
          Event.update_points(@event.profile_id, 5)
          redirect_to(@event)
        else
          redirect_to "http://www.google.com"
        end
      end
    rescue => e
      e
    end
  end
  
  def update
    if !session[:user_id].nil?
      @event = Event.find(params[:id])
	  if @event.update_attributes(params[:event])
		redirect_to event_path(@event)
      else
        redirect_to profile_path(session[:user_id])
      end
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
	@event.destroy
	respond_to do |format|
	  format.html { redirect_to profile_path(session[:user_id]) }
	  format.xml  { head :ok }
	end
  end
  
  def add_favourite
    @event = Event.find(params[:FavouriteEvent][:event_id])
    if FavouriteEvents.add_fav(params[:FavouriteEvent][:event_id],params[:FavouriteEvent][:profile_id]) == 1
      flash[:notice] = 'Event has been added to your favourites.'
    else
      flash[:notice] = 'Problem while adding to favourites.'
    end
    respond_to do|format|
      format.html {redirect_to(event_path(params[:FavouriteEvent][:event_id]))}
      format.js
    end
  end

  def remove_favourite
    @event = Event.find(params[:FavouriteEvent][:event_id])
    
    if FavouriteEvents.remove_fav(params[:FavouriteEvent][:event_id],params[:FavouriteEvent][:profile_id]) == 1
      flash[:notice] = 'Event has been removed from your favourites.'
    else
      flash[:notice] = 'Problem while removing from favorites.'
    end
    respond_to do|format|
      format.html {redirect_to(event_path(params[:FavouriteEvent][:event_id]))}
      format.js
    end
  end
  
  def add_comment
    if CommentEvent.new_comment(params[:CommentEvent][:event_id],params[:CommentEvent][:profile_id],params[:CommentEvent][:content]) == 1
      flash[:notice] = 'Comment was successfully updated.'
      @event_comments = CommentEvent.get_comments(params[:CommentEvent][:event_id])
    else
      flash[:notice] = 'Problem while commenting.'
    end
    respond_to do|format|
       format.html { redirect_to(event_path(params[:CommentEvent][:event_id]))}
       format.js
     end
  end
  
  def remove_comment
    @comment = CommentEvent.find(params[:id])
	@comment.destroy
	flash[:notice] = 'Comment was successfully deleted.'
	@document_comments = CommentEvent.get_comments(@comment.event_id)
    redirect_to event_path(@comment.event_id)
  end

  def vote_up
    if params[:CommentEvent][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(event_path(params[:CommentEvent][:event_id]))
	else
		@comment = CommentEvent.find(params[:CommentEvent][:comment_id])
		case CommentEvent.increase_rating(params[:CommentEvent][:profile_id],@comment)
		when 1 then
		  flash[:notice] = "Thanks for rating"
		when -1 then
		  flash[:notice] = "You have already rated"   
		when 0 then
		  flash[:notice] = "Error while rating"
		end
		respond_to do|format|
		  format.html { redirect_to(event_path(params[:CommentEvent][:event_id]))}
		  format.js
		end
	end
  end
  
  def vote_down
	if params[:CommentEvent][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(event_path(params[:CommentEvent][:event_id]))
	else
		@comment = CommentEvent.find(params[:CommentEvent][:comment_id])
		case CommentEvent.decrease_rating(params[:CommentEvent][:profile_id],@comment)
		when 1 then
		  flash[:notice] = "Thanks for rating"
		when -1 then
		  flash[:notice] = "You have already rated"   
		when 0 then
		  flash[:notice] = "Error while rating"
		end
		respond_to do|format|
			format.html { redirect_to(event_path(params[:CommentEvent][:event_id]))}
			format.js
		 end
	end
  end
  
  def event_vote_up
	if params[:event][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(event_path(params[:event][:event_id]))
	else
		@event = Event.find(params[:event][:event_id])

		case Event.increase_rating(params[:event][:profile_id],@event) == 1
		when 1 then
		  flash[:notice] = "Thanks for rating"
		when -1 then
		  flash[:notice] = "You have already rated"   
		when 0 then
		  flash[:notice] = "Error while rating"
		end
		respond_to do|format|
		  format.html { redirect_to(event_path(params[:event][:event_id]))}
		  format.js
		end
	end
  end
  
  def event_vote_down
	if params[:event][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(event_path(params[:event][:event_id]))
	else
		@event = Event.find(params[:event][:event_id])
		
		case Event.decrease_rating(params[:event][:profile_id],@event)
		when 1 then
		  flash[:notice] = "Thanks for rating"
		when -1 then
		  flash[:notice] = "You have already rated"   
		when 0 then
		  flash[:notice] = "Error while rating"
		end
		respond_to do|format|
			format.html { redirect_to(event_path(params[:event][:event_id]))}
			format.js
		end
	end
  end
  
  def report_comment_as_spam
	@comment = CommentEvent.find(params[:CommentEvent][:comment_event_id])
	mark_it_as_spam = CommentEvent.report_as_spam(@comment.id)
	redirect_to event_path(@comment.event_id)
  end
	
  def report_as_spam
	event_id = params[:event_id]
	@event = Event.find(event_id)
	mark_it_as_spam = Event.report_as_spam(event_id)
	if mark_it_as_spam == true
		Event.update_points(@event.profile_id, -5)
	end
	redirect_to event_path(event_id)
  end
end
