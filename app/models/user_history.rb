class UserHistory < ActiveRecord::Base
  belongs_to :profile
  belongs_to :event
  
  validates_presence_of :page_url
end
