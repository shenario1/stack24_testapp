require "common_functions.rb"
class AnswerRating < ActiveRecord::Base
  extend CommonFunctions
  
  belongs_to :profile
  belongs_to :answer
  
  validates_presence_of :profile_id, :answer_id, :user_rating
  validates_numericality_of :profile_id, :answer_id, :user_rating
  validates_inclusion_of :user_rating, :in =>[1,-1]
end
