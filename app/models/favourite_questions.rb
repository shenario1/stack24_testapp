require 'common_functions.rb'
class FavouriteQuestions < ActiveRecord::Base
  extend CommonFunctions
  
  validates_presence_of :profile_id, :question_id
  validates_numericality_of :profile_id, :question_id
  
  def self.add_fav(question_id,profile_id)
    begin
    @favorite = FavouriteQuestions.new
    @favorite.question_id = question_id
    @favorite.profile_id = profile_id
    if @favorite.save
      owner = Profile.update_points(profile_id, 3)
      1
    else
      0
    end
	 rescue
      "Please Try Again Later"
     end
  end
  
  
  def self.remove_fav(question_id,profile_id)
     begin
     @favorite = find(:all,:select=>"id",:conditions=>['question_id = ? AND profile_id = ?',question_id,profile_id])
     if !@favorite.nil?
       delete(@favorite)
       owner = Profile.update_points(profile_id, -3)
       1
     else
       0
     end
	 rescue
      "Please Try Again Later"
     end
   end
   
   
   def self.fav_status(question_id,profile_id)
     begin
     if count(:all,:conditions=>["question_id = ? AND profile_id = ?",question_id,profile_id]) > 0
          1
     else
          0
     end
	 rescue
      "Please Try Again Later"
     end
   end
   
end

