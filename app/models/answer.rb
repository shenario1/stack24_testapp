require 'common_functions.rb'
class Answer < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :profile
  belongs_to :question
  has_many :answer_ratings
  
  validates_presence_of :profile_id, :question_id, :answercontent, :reportspam
  validates_numericality_of :profile_id, :question_id, :rating, :reportspam

end
