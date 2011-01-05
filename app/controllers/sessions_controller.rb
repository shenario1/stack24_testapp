class SessionsController < ApplicationController
skip_before_filter :authenticate, :only => [:new, :destroy]
  def new
  end
  
  def destroy
    reset_session
    session[:user_id] = nil
    redirect_to root_path
  end  
end
