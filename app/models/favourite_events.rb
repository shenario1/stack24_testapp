require 'common_functions.rb'
class FavouriteEvents < ActiveRecord::Base
  extend CommonFunctions
  
  validates_presence_of :profile_id, :event_id
  validates_numericality_of :profile_id, :event_id
  
  def self.add_fav(event_id,profile_id)
    begin
    @favorite = FavouriteEvents.new
    @favorite.event_id = event_id
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
  
  
  def self.remove_fav(event_id,profile_id)
     begin
     @favorite = find(:all,:select=>"id",:conditions=>['event_id = ? AND profile_id = ?',event_id,profile_id])
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
   
   
   def self.fav_status(event_id,profile_id)
     begin
     if count(:all,:conditions=>["event_id = ? AND profile_id = ?",event_id,profile_id]) > 0
          1
     else
          0
     end
	 rescue
      "Please Try Again Later"
     end
   end
   
end
