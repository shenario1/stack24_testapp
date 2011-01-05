# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101128171626) do

  create_table "answer_ratings", :force => true do |t|
    t.integer  "profile_id",  :null => false
    t.integer  "answer_id",   :null => false
    t.integer  "user_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "profile_id",                    :null => false
    t.string   "answercontent", :default => "", :null => false
    t.integer  "question_id",                   :null => false
    t.integer  "rating",        :default => 0
    t.integer  "reportspam",    :default => 0
    t.integer  "points",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["answercontent"], :name => "index_answers_on_answercontent"

  create_table "comment_document_ratings", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "comment_document_id"
    t.integer  "user_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_documents", :force => true do |t|
    t.integer  "profile_id",                  :null => false
    t.string   "content",     :default => "", :null => false
    t.integer  "document_id",                 :null => false
    t.integer  "rating",      :default => 0
    t.integer  "reportspam",  :default => 0
    t.integer  "points",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_documents", ["content"], :name => "index_comment_documents_on_content"

  create_table "comment_event_ratings", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "comment_event_id"
    t.integer  "user_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_events", :force => true do |t|
    t.integer  "profile_id",                 :null => false
    t.string   "content",    :default => "", :null => false
    t.integer  "event_id",                   :null => false
    t.integer  "rating",     :default => 0
    t.integer  "reportspam", :default => 0
    t.integer  "points",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_events", ["content"], :name => "index_comment_events_on_content"

  create_table "document_ratings", :force => true do |t|
    t.integer  "profile_id",  :null => false
    t.integer  "document_id", :null => false
    t.integer  "user_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.integer  "profile_id",                        :null => false
    t.string   "doctitle",          :default => "", :null => false
    t.string   "tags",              :default => "", :null => false
    t.integer  "downloadcount",     :default => 0
    t.integer  "viewcount",         :default => 0
    t.integer  "rating",            :default => 0
    t.integer  "reportspam",        :default => 0
    t.integer  "points",            :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note_file_name"
    t.string   "note_content_type"
    t.integer  "note_file_size"
    t.datetime "note_updated_at"
    t.string   "swf_file_path"
  end

  add_index "documents", ["doctitle"], :name => "index_documents_on_doctitle"
  add_index "documents", ["tags"], :name => "index_documents_on_tags"

  create_table "event_ratings", :force => true do |t|
    t.integer  "profile_id",  :null => false
    t.integer  "event_id",    :null => false
    t.integer  "user_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "profile_id",                  :null => false
    t.string   "event_name",  :default => "", :null => false
    t.string   "event_place", :default => ""
    t.string   "description", :default => ""
    t.string   "website"
    t.integer  "rating",      :default => 0
    t.integer  "reportspam",  :default => 0
    t.integer  "points",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "event_date"
    t.integer  "viewcount"
  end

  add_index "events", ["event_name"], :name => "index_events_on_event_name"
  add_index "events", ["event_place"], :name => "index_events_on_event_place"

  create_table "favourite_documents", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favourite_events", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "profiles", :force => true do |t|
    t.string   "email",                                 :null => false
    t.date     "dob"
    t.integer  "sex"
    t.integer  "status"
    t.string   "institute",             :default => ""
    t.string   "city",                  :default => ""
    t.string   "state",                 :default => ""
    t.string   "openid",                                :null => false
    t.integer  "points",                :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "disp_pic_file_name"
    t.string   "disp_pic_content_type"
    t.integer  "disp_pic_file_size"
    t.datetime "disp_pic_updated_at"
    t.string   "name"
  end

  add_index "profiles", ["email"], :name => "index_profiles_on_email"
  add_index "profiles", ["openid"], :name => "index_profiles_on_openid"

  create_table "searches", :force => true do |t|
    t.string   "searchterm"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_histories", :force => true do |t|
    t.integer  "profile_id"
    t.string   "page_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
