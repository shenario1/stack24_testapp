require "common_functions.rb"
class CommentDocument < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :profile
  belongs_to :document  
  has_many :comment_document_ratings
  
  validates_presence_of :profile_id, :document_id, :content
  validates_numericality_of :profile_id, :document_id, :reportspam, :rating
  validates_length_of :content, :within => 3..200
  
  
  def self.new_comment(document_id,profile_id,content)
      begin
        @comment = CommentDocument.new
        @comment.document_id = document_id
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
   
   def self.get_comments(document_id)
       begin
         find(:all,:conditions=>['document_id = ?',document_id])  
       rescue 
         -1
       end
   end
   
end