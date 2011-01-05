class CommentDocumentRating < ActiveRecord::Base
  belongs_to :profile
  belongs_to :comment_document
  
  validates_presence_of :profile_id, :comment_document_id, :user_rating
  validates_numericality_of :profile_id, :comment_document_id, :user_rating
  validates_inclusion_of :user_rating, :in => [1,-1]
  
end