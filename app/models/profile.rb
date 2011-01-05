require 'common_functions.rb'
class Profile < ActiveRecord::Base
  extend CommonFunctions
  has_many :documents
  has_many :comments
  has_many :questions
  has_many :answers
  has_many :follow_question
  has_many :events
  has_attached_file :disp_pic, 
  #:styles => { :small => "150x150>" },
  :url => "/assets/profiles/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/profiles/:id/:style/:basename.:extension" 
  
  attr_accessible :name, :email, :sex, :city, :dob, :disp_pic, :openid, :institute, :state, :status, :delete_disp_pic
  
  #callbacks
  before_validation :clear_disp_pic
  
  #validations
  validates_presence_of :name, :email, :openid
  validates_uniqueness_of :email, :openid
  validates_format_of :email, :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_inclusion_of :sex, :in => [1,2], :allow_blank => true
  validates_inclusion_of :status, :in => [1,2], :allow_blank => true
  validates_length_of :name, :within => 3..15
  validates_format_of :city, :with => /^[a-zA-Z][a-zA-Z\\s]+$/i, :allow_blank => true
  #validates_format_of :state, :with => /^[a-zA-Z][a-zA-Z\\s]+$/i, :allow_blank => true
  #validates_format_of :institute, :with => /^[a-zA-Z][a-zA-Z\\s]+$/i, :allow_blank => true
  #validates_attachment_presence :disp_pic  
  validates_attachment_size :disp_pic, :less_than => 1.megabyte  
  validates_attachment_content_type :disp_pic, :content_type => ['image/jpeg', 'image/png']  
  
  
  
  def delete_disp_pic=(value)
    @delete_disp_pic = !value.to_i.zero?
  end
  
  def delete_disp_pic
    !!@delete_disp_pic
  end
  alias_method :delete_disp_pic?, :delete_disp_pic
  
  def clear_disp_pic
    self.disp_pic = nil if delete_disp_pic?
  end

end
