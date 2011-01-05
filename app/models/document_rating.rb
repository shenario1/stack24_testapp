require "common_functions.rb"
class DocumentRating < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :profile
  belongs_to :document

  validates_presence_of :profile_id, :document_id, :user_rating
  validates_numericality_of :profile_id, :document_id, :user_rating
  validates_inclusion_of :user_rating, :in =>[1,-1]
end
