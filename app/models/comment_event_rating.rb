class CommentEventRating < ActiveRecord::Base
  belongs_to :profile
  belongs_to :comment_event
  
  validates_presence_of :profile_id, :comment_event_id, :user_rating
  validates_numericality_of :profile_id, :comment_event_id, :user_rating
  validates_inclusion_of :user_rating, :in => [1,-1]
  
end