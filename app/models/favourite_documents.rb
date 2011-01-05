require 'common_functions.rb'
class FavouriteDocuments < ActiveRecord::Base
  extend CommonFunctions
  
  validates_presence_of :profile_id, :document_id
  validates_numericality_of :profile_id, :document_id
  
  def self.add_fav(document_id,profile_id)
    begin
		@favorite = FavouriteDocuments.new
		@favorite.document_id = document_id
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
  
  
  def self.remove_fav(document_id,profile_id)
     begin
		 @favorite = find(:all,:select=>"id",:conditions=>['document_id = ? AND profile_id = ?',document_id,profile_id])
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
   
   
   def self.fav_status(document_id,profile_id)
     begin
		 if count(:all,:conditions=>["document_id = ? AND profile_id = ?",document_id,profile_id]) > 0
			  1
		 else
			  0
		 end
	 rescue
      "Please Try Again Later"
     end
   end
   
end
