require "common_functions.rb"
class Document < ActiveRecord::Base
  extend CommonFunctions
  belongs_to :profile
  has_many :comment_documents
  has_many :user_histories
  has_many :document_ratings
  
  has_attached_file :note,
  :url => "/assets/documents/:id/:basename.:extension",
  :path => ":rails_root/public/assets/documents/:id/:basename.:extension"
  
  #validations
  validates_presence_of :profile_id, :doctitle, :tags, :note, :reportspam
  validates_numericality_of :profile_id, :reportspam, :rating
  validates_length_of :doctitle, :within => 3..150
  validates_attachment_presence :note  
  validates_attachment_size :note, :less_than => 5.megabytes  
  #validates_attachment_content_type :note, :content_type => ['application/pdf', 'application/msword']  
  
  def self.convert2SWF(doc_id)
	document = Document.find(doc_id)
    local_file = document.note.path
	local_file_url = document.note.url
	
	# if local_file.include? " "
		# local_file_w_space = local_file
		# local_file = local_file.gsub(' ','_')
		# local_file_url = local_file_url.gsub(' ','_')
		# system "mv #{local_file_w_space} #{local_file}"
		# document.note.path = local_file
		# document.note.url = local_file_url
	# end
	
	 extension = File.extname(local_file).gsub(/^\.+/, '')
	# filename = local_file.gsub(/\.#{extension}$/, '')
	 file_url = local_file_url.gsub(/\.#{extension}.*$/, '')	
	# swf_file = "#{filename}.swf"
	
	#if !extension.eql?('pdf')
	#	local_file = Document.convert2PDF(local_file)
	#end
	#system "pdf2swf #{local_file} -o #{swf_file}"
	
	local_file_path = File.dirname(local_file)
	system "p2s.bat #{local_file_path}"
	
	#if !document.swf_file_path.blank?
	#	system "rm #{document.swf_file_path}"
	#end
	
	document.swf_file_path = "#{file_url}.swf"
	if document.save
	 true
	else
	 false
	end
  end
end
