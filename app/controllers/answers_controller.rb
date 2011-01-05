class AnswersController < ApplicationController
before_filter :only =>[:edit,:destroy] do |controller| 
	controller.send(:object_correct_user, "Answer")
end
#layout 'application', :except=>[:update_answer]
  # GET /answers/new
  # GET /answers/new.xml
  def new
    begin
      @answer = Answer.new
      @answer.profile_id = session[:user_id]
    rescue
      flash.now[:error] = "Cannot create a new answer."
      redirect_to questions_path
    end
  end

  # GET /answers/1/edit
  def edit
	begin
      @answer = Answer.find(params[:id])
    rescue
      redirect_to (questions_path)
    end
  end
  
  # GET /answers/1
  # GET /answers/1.xml
  def show
    begin
      @answer = Answer.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @answer }
      end
    rescue
      redirect_to (questions_path)
    end
  end

  # POST /answers
  # POST /answers.xml
  def create
    #begin
      @answer = Answer.new(params[:answer])
      @answer.profile_id = params[:Answer][:profile_id]
      @answer.question_id = params[:Answer][:question_id]
      @answer.answercontent = params[:Answer][:answercontent]
      @answer.rating = 0
      respond_to do |format|
        if @answer.save
          Answer.update_points(@answer.profile_id, 5)
          
          #insert a record into the follow_question table
          #search for the people who have already answered this question and send a mail about the new answer and also the
          #owner of the question
          FollowQuestion.add_follow_question(@answer.question_id, session[:user_id])
          
          flash[:notice]  = 'Answer was successfully created.'
          format.html { redirect_to(question_path(params[:Answer][:question_id])) }
          format.xml  { render :xml => @answer, :status => :created, :location => @answer }
        else
          format.html { redirect_to(question_path(params[:Answer][:question_id])) }
          format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
        end
      end
    #rescue
      #redirect_to (profile_url(session[:user_id]))
    #end
  end

  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    begin
      @answer = Answer.find(params[:id])
	  if @answer.update_attributes(params[:answer])
		flash[:notice] = 'Answer was successfully updated.'
		redirect_to(question_path(@answer.question_id))
	  else
		render 'edit'
	  end
    rescue
      flash.now[:error] = "Question is currently unavailable"
      redirect_to(questions_path)
    end
  end
  
  # def update_answer
    # begin
      # @answer = Answer.find(params[:id])
	  # @answer.answercontent = params[:answercontent]
	  # @answer.save
	  # flash[:notice] = 'Answer was successfully updated.'
	# rescue
      # flash.now[:error] = "Question is currently unavailable"
    # end
  # end
  
  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    begin
      @answer = Answer.find(params[:id])
	  question_id = @answer.question_id
	  @answer.destroy
	  respond_to do |format|
		format.html { redirect_to(question_path(question_id)) }
		format.xml  { head :ok }
	  end
    rescue
      redirect_to (profile_url(session[:user_id]))
    end
  end
  
  def vote_up
    begin
	  if params[:Answer][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(question_path(params[:Answer][:question_id]))
	  else
		@answer = Answer.find(params[:Answer][:answer_id])
		case Answer.increase_rating(params[:Answer][:profile_id],@answer)
		  when 1 then
			flash[:notice] = "Thanks for rating"
		  when -1 then
			flash[:notice] = "You have already rated"   
		  when 0 then
			flash[:notice] = "Error while rating"
		end
		respond_to do|format|
		  format.html { redirect_to(question_path(params[:Answer][:question_id]))}
		  format.js
		 end
	  end  
      rescue
        redirect_to (question_path(params[:Answer][:question_id]))
      end
  end
  
  def vote_down
    begin
	  if params[:Answer][:profile_id] == session[:user_id]
		flash[:notice] = "Cannot self rate up or down stuff posted by you."
		redirect_to(question_path(params[:Answer][:question_id]))
	  else
        @answer = Answer.find(params[:Answer][:answer_id])
        case Answer.decrease_rating(params[:Answer][:profile_id],@answer)
         when 1 then
          flash[:notice] = "Thanks for rating"
         when -1 then
          flash[:notice] = "You have already rated"   
         when 0 then
          flash[:notice] = "Error while rating"
        end
        respond_to do|format|
         format.html { redirect_to(question_path(params[:Answer][:question_id]))}
         format.js
        end
	  end
     rescue
       redirect_to (question_path(params[:Answer][:question_id]))
     end
  end
  
  def report_as_spam
	@answer = Answer.find(params[:Answer][:answer_id])
	mark_it_as_spam = Answer.report_as_spam(@answer.id)
	if mark_it_as_spam == true
		Answer.update_points(@answer.profile_id, -5)
	end
	redirect_to question_path(@answer.question_id)
  end
  
end
