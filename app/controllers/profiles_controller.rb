class ProfilesController < ApplicationController  
skip_before_filter :authenticate, :only => [:new, :create]
before_filter :correct_user, :only => [:edit]

  def new
    @profile = Profile.new
    @title = "Create Profile"
    user_params = Profile.checkopenid(params[:token])
    if user_params != -1
      user_detail = user_params.split(' ')
      user_check = Profile.find_by_email(user_detail[1])
      if !user_check
        @profile.email = user_detail[1]
        @profile.openid = user_detail[0]
        respond_to do |format|
          format.html
          format.xml  { render :xml => @profile }
        end
      else
        if session[:user_id].nil?
            session[:user_id] = user_check.id
        end
        redirect_back_or user_check
      end
    else
      flash[:notice] = "Login Failed"
      redirect_to signin_path
    end
  end
  
  def edit
    @profile = Profile.find(params[:id])
    @title = "Edit Profile - #{@profile.name}"
  end
  
  def index
    @profiles = Profile.all
  end
  
  def show
    @profile = Profile.find(params[:id])
    UserHistory.create!(:page_url => request.url, :profile_id => session[:user_id])
    @title = @profile.name
  end
  
  def create
    @profile = Profile.new(params[:profile])

    respond_to do |format|
      if @profile.save
		CommonMailer.deliver_create_profile(@profile.email, @profile.name)
        session[:user_id] = @profile.id
        session[:email] = @profile.email
        session[:name] = @profile.name
        flash[:notice] = 'Profile was successfully created.'
        format.html { redirect_to profile_path(@profile) }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @profile = Profile.find(params[:id])
    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to(@profile) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def favourites
	profile_id = params[:profile_id]
	@toggle = params[:toggle] || "all"
	page = params[:page]
    @title = "Favourites"
    #UserHistory.create!(:page_url => request.url, :profile_id => session[:user_id])
	@favourites = {}
	@favourites[:documents] = []
	@favourites[:questions] = []
	@favourites[:events] = []
	@favourites[:all] = []
	@favourites[:documents] = FavouriteDocuments.find(:all,:conditions=>["profile_id = ?",profile_id])
	@favourites[:questions] = FavouriteQuestions.find(:all,:conditions=>["profile_id = ?",profile_id])
	@favourites[:events] = FavouriteEvents.find(:all,:conditions=>["profile_id = ?",profile_id])
	@favourites[:all] = @favourites.values_at(:documents,:questions,:events).flatten.compact
	case @toggle
		when "documents"
			if !@favourites[:documents].nil?
				@favourites[:documents] = @favourites[:documents].paginate(:per_page=>@per_page,:page => page)
			end
		when "questions"
			if !@favourites[:questions].nil?
				@favourites[:questions] = @favourites[:questions].paginate(:per_page=>@per_page,:page => page)
			end
		when "events"
			if !@favourites[:events].nil?
				@favourites[:events] = @favourites[:events].paginate(:per_page=>@per_page,:page => page)
			end
		when "all"
			if !@favourites[:all].nil?
				@favourites[:all] = @favourites[:all].paginate(:per_page=>@per_page,:page => page)
			end
	end
  end
  
  def dashboard
	@profile = Profile.find(current_user)
	@title = "#{@profile.name}'s Dashboard"
  end
  
end
