require "common_functions.rb"
class EventRating < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :profile
  belongs_to :event

  validates_presence_of :profile_id, :event_id, :user_rating
  validates_numericality_of :profile_id, :event_id, :user_rating
  validates_inclusion_of :user_rating, :in =>[1,-1]
end
