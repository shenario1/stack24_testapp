require 'common_functions.rb'
class Search < ActiveRecord::Base
  extend CommonFunctions
  def self.columns()
    @columns ||= [];
  end
  
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  column :searchterm, :string
  
  validates_presence_of :searchterm
  
  #Code for calculating Recommendation
  def self.search(searchterm)
    @stripped_search_string = []
      searchterms = searchterm.downcase.split
      searchtags = []
      searchusers = []
      searchwords = []
      
      searchterms.each do |term|
        if $COMMON_WORDS.index(term) == nil
          if term[0] == "#"
              searchtags << term
          elsif term[0] == "@"
              searchusers << term
          else
              searchwords << term
          end
        end
      end
    
    if !searchtags.empty? && searchwords.empty? && searchusers.empty?
      search_results = Search.tag_search(searchtags)
    elsif searchtags.empty? && searchwords.empty? && !searchusers.empty?
      search_results = Search.profile_search(searchusers)
    elsif searchtags.empty? && !searchwords.empty? && searchusers.empty?
      search_results = Search.all_search(searchwords) 
    elsif !searchtags.empty? && !searchwords.empty? && searchusers.empty?
      search_results = Search.word_and_tag_search(searchwords, searchtags)
    elsif !searchtags.empty? && searchwords.empty? &&  !searchusers.empty?
      search_results = Search.profile_and_tag_search(searchusers, searchtags)
    elsif !searchtags.empty? && !searchwords.empty? &&  !searchusers.empty?
      search_results = Search.profile_tag_word_search(searchusers, searchtags, searchwords)
    end
  end  
  
  
  def self.questions_search(searchterm)
    questions_search = ""
    searchterm.each do|search|
      if !questions_search.blank?
         questions_search = questions_search + " OR questitle LIKE \"%#{search}%\" OR question_info LIKE \"%#{search}%\""
      else
        questions_search = "questitle LIKE \"%#{search}%\" OR question_info LIKE \"%#{search}%\""
      end
    end
    @questions_sql = Question.find_by_sql("Select distinct id,questitle,question_info,tags,profile_id from questions Where #{questions_search} order by rating")
  end
  
  def self.document_search(searchterm)
      document_search = ""
      searchterm.each do|search|
        if !document_search.blank?
           document_search = document_search + " OR doctitle LIKE \"%#{search}%\""
        else
          document_search = "\"%#{search}%\""
        end
      end
      @document_sql = Document.find_by_sql("Select distinct id,doctitle,tags,profile_id from documents Where doctitle LIKE #{document_search} order by rating")
  end
  
  def self.event_search(searchterm)
    event_search = ""
    searchterm.each do|search|
      if !event_search.blank?
         event_search = event_search + " OR event_name LIKE \"%#{search}%\""
      else
        event_search = "\"%#{search}%\""
      end
    end
    current_date = Time.now
    #2_months_from_now = 2.months.from_now
    @event_sql = Event.find_by_sql("Select distinct id,event_name,event_place,profile_id from events Where event_name LIKE #{event_search}  AND event_date  >= \"#{current_date}\" order by event_date ")
  end
  
  def self.profile_search(searchterm)
     profiles = ""
     searchterm.each do|search|
       current = search[1..search.length]
       if !profiles.blank?
          profiles = profiles + " OR name LIKE \"%#{current}%\""
       else
          profiles = "name LIKE \"%#{current}%\""
       end
     end

     profile_search = {}
     profile_search[:profile_results] = Profile.find_by_sql("Select distinct id,name from profiles Where #{profiles}")
	 profile_search[:search_count] = profile_search[:profile_results].count
     profile_search
  end
  
  def self.all_search(searchterm)
    all_search = {}
    all_search [:document_results] = Search.document_search(searchterm)
    all_search [:question_results] = Search.questions_search(searchterm)
    all_search [:event_results] = Search.event_search(searchterm)
	all_search [:profile_results] = Search.profile_search(searchterm)[:profile_results]
	all_search [:search_count] = all_search [:document_results].count + all_search [:question_results].count + all_search [:event_results].count + all_search [:profile_results].count
    all_search
  end    
    
  def self.tag_search(searchterm)
    tags = ""
    searchterm.each do|search|
      current = search[1..search.length]
      if !tags.blank?
         tags = tags + " AND tags LIKE \"%#{current}%\""
      else
         tags = "\"%#{current}%\""
      end
    end
    
    tag_search = {}
    tag_search[:document_results] = Search.document_tags_search(tags)
    tag_search[:question_results] = Search.question_tags_search(tags)
	tag_search[:search_count] = tag_search[:document_results].count + tag_search[:question_results].count
    tag_search
  end
  
  def self.document_tags_search(searchterm)
      @document_tag_sql = Document.find_by_sql("Select distinct id,doctitle,tags,profile_id from documents Where tags LIKE #{searchterm} order by rating")
  end
  
  def self.question_tags_search(searchterm)
      @question_tag_sql = Question.find_by_sql("Select distinct id,questitle,question_info,tags,profile_id from questions Where tags LIKE #{searchterm} order by rating")
  end
  
  
  def self.word_and_tag_search(searchwords,searchtags)
    search_results = {}
    
    document_where_clause = Search.build_document_words_where_clause(searchwords) + " AND " + Search.build_document_tags_where_clause(searchtags)
    question_where_clause = Search.build_question_words_where_clause(searchwords) + " AND " + Search.build_question_tags_where_clause(searchtags)
    
    search_results[:document_results] = Document.find_by_sql("Select distinct D.id, D.doctitle, D.profile_id, D.tags  from documents D Where #{document_where_clause}")
    search_results[:question_results] = Question.find_by_sql("Select distinct Q.id, Q.questitle, Q.question_info, Q.profile_id, Q.tags  from questions Q Where #{question_where_clause}")
	search_results[:search_count] = search_results[:document_results].count + search_results[:question_results].count
    search_results
  end
  
  def self.profile_and_tag_search(searchusers, searchtags)
    search_results = {}
    
    document_where_clause = Search.build_document_tags_where_clause(searchtags) + " AND " + Search.build_profile_where_clause(searchusers)
    question_where_clause = Search.build_question_tags_where_clause(searchtags) + " AND " + Search.build_profile_where_clause(searchusers)

    search_results[:document_results] = Document.find_by_sql("Select distinct D.id, D.doctitle, D.profile_id, D.tags  from documents D, profiles P Where #{document_where_clause}")
    search_results[:question_results] = Question.find_by_sql("Select distinct Q.id, Q.questitle, Q.question_info, Q.profile_id, Q.tags  from questions Q, profiles P Where #{question_where_clause}")
	
	search_results[:search_count] = search_results[:document_results].count + search_results[:question_results].count

    search_results
  end
  
  def self.profile_tag_word_search(searchusers, searchtags, searchwords)
    search_results = {}
    where_clause = " "
    
    document_where_clause = Search.build_document_tags_where_clause(searchtags)
    document_where_clause = document_where_clause + " AND " + Search.build_profile_where_clause(searchusers)
    document_where_clause = document_where_clause + " AND " + Search.build_document_words_where_clause(searchwords)
    
    question_where_clause = Search.build_question_tags_where_clause(searchtags)
    question_where_clause = question_where_clause + " AND " + Search.build_question_words_where_clause(searchwords)
    question_where_clause = question_where_clause + " AND " + Search.build_profile_where_clause(searchusers)
    
    
    search_results[:document_results] = Document.find_by_sql("Select distinct D.id, D.doctitle, D.profile_id, D.tags  from documents D, profiles P Where #{document_where_clause}")
    search_results[:question_results] = Question.find_by_sql("Select distinct Q.id, Q.questitle, Q.question_info, Q.profile_id, Q.tags  from questions Q, profiles P Where #{question_where_clause}")
    search_results[:search_count] = search_results[:document_results].count + search_results[:question_results].count
    search_results
  end
  
  def self.build_document_words_where_clause(searchwords)
    where_clause = ""
    
    searchwords.each do|term|
      if !where_clause.blank?
         where_clause = where_clause + " OR (D.doctitle LIKE \"%#{term}%\")"
      else
        where_clause = "(D.doctitle LIKE \"%#{term}%\")"
      end
    end
    where_clause
  end
  
  def self.build_document_tags_where_clause(searchtags)
    where_clause = ""
    current_tag = ""
    
    searchtags.each do|term|
      current_tag = term[1..term.length]
      if !where_clause.blank?
         where_clause = where_clause + " AND (D.tags LIKE \"%#{current_tag}%\")"
      else
        where_clause = " (D.tags LIKE \"%#{current_tag}%\") "
      end
      current_tag = ""
    end
    where_clause
  end
  
  def self.build_question_words_where_clause(searchwords)
    where_clause = ""
    
    searchwords.each do|term|
      if !where_clause.blank?
         where_clause = where_clause + " OR (Q.questitle LIKE \"%#{term}%\" OR Q.question_info LIKE \"%#{term}%\")"
      else
        where_clause = "((Q.questitle LIKE \"%#{term}%\" OR Q.question_info LIKE \"%#{term}%\")"
      end
    end
    where_clause
  end
  
  def self.build_question_tags_where_clause(searchtags)
    where_clause = ""
    current_tag = ""
    searchtags.each do|term|
      puts "Search Tag: #{term}"
      current_tag = term[1..term.length]
      puts "Current Tag: #{current_tag}"
      if !where_clause.blank?
         where_clause = where_clause + " AND (Q.tags LIKE \"%#{current_tag}%\")"
      else
        where_clause = "(Q.tags LIKE \"%#{current_tag}%\")"
      end
      current_tag = ""
    end
    where_clause
  end
  
  def self.build_profile_where_clause(searchusers)
    where_clause = ""
    
    searchusers.each do|search|
      current = search[1..search.length]
      if !where_clause.blank?
         where_clause = where_clause + " OR (P.name LIKE \"%#{current}%\")"
      else
         where_clause = "(P.name LIKE \"%#{current}%\")"
      end
      current = ""
    end
    
    where_clause
  end
  
  def self.build_other_where_clause(searchwords)
    where_clause = ""
    
    where_clause = Search.build_question_words_where_clause(searchwords)
    where_clause = where_clause + " AND " + Search.build_document_words_where_clause(searchwords)
    where_clause
  end
end
