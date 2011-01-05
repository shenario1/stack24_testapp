# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :openid
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :authenticate, :except => [:show, :index]
  protected
  def current_user
      @current_user ||= Profile.find_by_id(session[:user_id])
  end
  
  helper_method :current_user, :gender_list, :current_user_name, :authenticate, :current_user

  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'application' } 

  def current_user=(user)
      session[:user_id] = user.try(:id)
      @current_user = user
  end
  
  def gender_list
    gender_list = {:Male => 1, :Female => 2}
    gender_list
  end
  
  def current_user_name
    Profile.find(current_user).name
  end
  
  def authenticate
	deny_access unless signed_in?
  end
  
  def correct_user
	@user = Profile.find_by_id(params[:id])
	if @user != current_user
		flash[:notice] = "Access Denied"
		redirect_to(profile_path(current_user))
	end
  end
  
  def object_correct_user type
	case type
		when "Document"
			object = Document.find(params[:id])
		when "Question"
			object = Question.find(params[:id])
		when "Event"
			object = Event.find(params[:id])
		when "CommentDocument"
			object = CommentDocument.find(params[:id])
		when "CommentEvent"
			object = CommentEvent.find(params[:id])
		when "Answer"
			object = Answer.find(params[:id])
	end			
	user = object.profile_id
	if user != session[:user_id]
		flash[:notice] = "Access Denied"
		redirect_to(profile_path(current_user))
	end
  end
    
  def signed_in?
    !current_user.nil?
  end

  def deny_access
    store_location
    flash[:notice] = "Please sign in to access this page."
	redirect_to signin_path
  end

  def store_location
    session[:return_to] = params[:this_page] || request.request_uri
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end
  
end
