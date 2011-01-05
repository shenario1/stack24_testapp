require "common_functions.rb"
class CommentEvent < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :profile
  belongs_to :event
  has_many :comment_event_ratings
  
  validates_presence_of :profile_id, :event_id, :content
  validates_numericality_of :profile_id, :event_id, :reportspam, :rating
  validates_length_of :content, :within => 3..200
  
  
  def self.new_comment(event_id,profile_id,content)
      begin
        @comment = CommentEvent.new
        @comment.event_id = event_id
        @comment.profile_id = profile_id
        @comment.content = content
        @comment.rating = 0
        if @comment.save
			1
		else
           -1
        end
      rescue
        -1
      end
  end
   
   def self.get_comments(event_id)
       begin
         find(:all,:conditions=>['event_id = ?',event_id])  
       rescue 
         -1
       end
   end
   
end