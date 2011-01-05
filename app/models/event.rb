require 'common_functions.rb'
class Event < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :profile
  has_many :user_histories
  has_many :comment_events
  has_many :event_ratings
  
  validates_presence_of :profile_id, :event_name, :event_date, :reportspam
  validates_numericality_of :profile_id, :reportspam, :rating
  validates_length_of :event_name, :within => 2..150
  validates_length_of :event_place, :maximum => 25
  validates_length_of :description, :maximum => 150
  validates_format_of :event_date, :with => /^[0-9]{4}[-][0-9]{2}[-][0-9]{2}$/i

end
