class DocumentsController < ApplicationController
before_filter :only =>[:edit,:destroy] do |controller| 
	controller.send(:object_correct_user, "Document")
end
before_filter :only =>[:remove_comment] do |controller| 
	controller.send(:object_correct_user, "CommentDocument")
end
  def new
    begin
      @title = "Create a New Document"
      @document = Document.new
	  @document.profile_id = session[:user_id]
    rescue
      flash.now[:error] = "Cannot create a new document."
      redirect_to documents_path
    end
  end

  def edit
    begin
      @document = Document.find(params[:id])
	  @title = "Editing #{@document.doctitle}"
    rescue
      flash.now[:error] = "Cannot edit the document"
      redirect_to documents_path
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
			@documents = Document.paginate :per_page => @per_page, :page => page,
										   :conditions => ["profile_id = ? ",session[:user_id]],
									       :order => order
			@title = "My Documents"
		end
	 else
	    @documents = Document.paginate :per_page => @per_page, :page => page,
									   :order => order
		@title = "Documents"
	 end
   rescue
     redirect_to profile_path(session[:user_id])
   end
  end

  def show
    #begin
      @document = Document.find(params[:id])
	  
      UserHistory.create!(:page_url => request.url, :profile_id => session[:user_id])
      @title = "#{@document.doctitle}"
      
      if !session[:user_id].nil?
         @owner = Document.is_owner(params[:id],session[:user_id])
         @fav_status = FavouriteDocuments.fav_status(@document.id,session[:user_id])
      else
         @owner = Document.is_owner(params[:id],nil)
         @fav_status = 0
      end
	  @related_documents = Document.related_documents(@document.id)
      if Document.change_viewcount(params[:id]) == -1
        flash[:notice] = 'Error while increasing the view count'
      end

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @document }
      end
     #rescue
      # flash.now[:error] = "Document is currently unavailable"
      # redirect_to (:action => :index)
     #end
  end
  
  def create
    @document = Document.new(params[:document])
    @document.points = 0
	
    if @document.save
	 
     if Document.convert2SWF(@document.id)
	 	 Document.update_points(@document.profile_id,10)
		 flash[:success] = "Your document has been created"
		 redirect_to document_path(@document)
	 end
    else
      flash[:error] = "Please give the required document details"
      @title = "Create a New Document"
      render 'new'
    end
  end

  def update
    begin
      @document = Document.find(params[:id])
	  if @document.update_attributes(params[:document])
		
		if Document.convert2SWF(@document.id)
			flash[:success] = "Document updated successfully."
			redirect_to @document
		end
      else
        @title = "Editing #{@document.doctitle}"
        render 'edit'
      end
    rescue
      flash.now[:error] = "Document is currently unavailable"
      redirect_to  :url => {:controller => :documents, :action => :index}
    end
  end

  def destroy
	@document = Document.find(params[:id])
	@document.destroy
	respond_to do |format|
	  format.html { redirect_to profile_path(session[:user_id]) }
	  format.xml  { head :ok }
	end
  end
 
  def add_favourite
    @document = Document.find(params[:FavouriteDocument][:document_id])
    if FavouriteDocuments.add_fav(params[:FavouriteDocument][:document_id],params[:FavouriteDocument][:profile_id]) == 1
      flash[:notice] = 'Document has been added to your favourites.'
    else
      flash[:notice] = 'Problem while adding to favourites.'
    end
    respond_to do|format|
      format.html {redirect_to(document_path(params[:FavouriteDocument][:document_id]))}
      format.js
    end
  end

  def remove_favourite
    @document = Document.find(params[:FavouriteDocument][:document_id])
    
    if FavouriteDocuments.remove_fav(params[:FavouriteDocument][:document_id],params[:FavouriteDocument][:profile_id]) == 1
      flash[:notice] = 'Document has been removed from your favourites.'
    else
      flash[:notice] = 'Problem while removing from favourites.'
    end
    respond_to do|format|
      format.html {redirect_to(document_path(params[:FavouriteDocument][:document_id]))}
      format.js
    end
  end
  
  def add_comment
    if CommentDocument.new_comment(params[:CommentDocument][:document_id],params[:CommentDocument][:profile_id],params[:CommentDocument][:content]) == 1
      flash[:notice] = 'Comment was successfully updated.'
      @document_comments = CommentDocument.get_comments(params[:CommentDocument][:document_id])
    else
      flash[:notice] = 'Problem while commenting.'
    end
    respond_to do|format|
       format.html { redirect_to(document_path(params[:CommentDocument][:document_id]))}
       format.js
     end
  end
  
  def remove_comment
    @comment = CommentDocument.find(params[:id])
	@comment.destroy
	flash[:notice] = 'Comment was successfully deleted.'
	@document_comments = CommentDocument.get_comments(@comment.document_id)
    redirect_to document_path(@comment.document_id)
  end

  def vote_up
	if params[:CommentDocument][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(document_path(params[:CommentDocument][:document_id]))
	else
	 @comment = CommentDocument.find(params[:CommentDocument][:comment_id])
	 case CommentDocument.increase_rating(params[:CommentDocument][:profile_id],@comment)
	 when 1 then
        flash[:notice] = "Thanks for rating"
     when -1 then
        flash[:notice] = "You have already rated"   
     when 0 then
        flash[:notice] = "Error while rating"
     end
	 respond_to do|format|
		format.html { redirect_to(document_path(params[:CommentDocument][:document_id]))}
		format.js
	 end
	end
  end
  
  def vote_down
	if params[:CommentDocument][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(document_path(params[:CommentDocument][:document_id]))
	else
		@comment = CommentDocument.find(params[:CommentDocument][:comment_id])
		case CommentDocument.decrease_rating(params[:CommentDocument][:profile_id],@comment)
		when 1 then
		  flash[:notice] = "Thanks for rating"
		when -1 then
		  flash[:notice] = "You have already rated"   
		when 0 then
		  flash[:notice] = "Error while rating"
		end
		respond_to do|format|
			format.html { redirect_to(document_path(params[:CommentDocument][:document_id]))}
			format.js
		end
	end
  end
  
  def document_vote_up
	if params[:document][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(document_path(params[:document][:document_id]))
	else
		@document = Document.find(params[:document][:document_id])

		case Document.increase_rating(params[:document][:profile_id],@document)
		when 1 then
		  flash[:notice] = "Thanks for rating"
		when -1 then
		  flash[:notice] = "You have already rated"   
		when 0 then
		  flash[:notice] = "Error while rating"
		end
		respond_to do|format|
		  format.html { redirect_to(document_path(params[:document][:document_id]))}
		  format.js
		end
	end
  end
  
  def document_vote_down
	if params[:document][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(document_path(params[:document][:document_id]))
	else
		@document = Document.find(params[:document][:document_id])
		
		case Document.decrease_rating(params[:document][:profile_id],@document)
		when 1 then
		  flash[:notice] = "Thanks for rating"
		when -1 then
		  flash[:notice] = "You have already rated"   
		when 0 then
		  flash[:notice] = "Error while rating"
		end
		respond_to do|format|
			format.html { redirect_to(document_path(params[:document][:document_id]))}
			format.js
		end
	end
  end
  
  def report_comment_as_spam
	@comment = CommentDocument.find(params[:CommentDocument][:comment_document_id])
	mark_it_as_spam = CommentDocument.report_as_spam(@comment.id)
	redirect_to document_path(@comment.document_id)
  end
  
  def report_as_spam
    document_id = params[:document_id]
	@document = Document.find(document_id)
    mark_it_as_spam = Document.report_as_spam(document_id)
	if mark_it_as_spam == true
		Document.update_points(@document.profile_id, -10)
	end
	redirect_to document_path(document_id)
  end

end
