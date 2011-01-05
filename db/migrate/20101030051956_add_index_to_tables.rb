class AddIndexToTables < ActiveRecord::Migration
  def self.up
	add_index(:documents, :doctitle)
    add_index(:documents, :tags)
	add_index(:questions, :question_info)
    add_index(:questions, :tags)
    add_index(:answers, :answercontent)
    add_index(:events, :event_name)
    add_index(:events, :event_place)
    add_index(:comment_documents, :content)
	add_index(:comment_events, :content)
    add_index(:profiles, :firstname)
    add_index(:profiles, :lastname)
	add_index(:profiles, :email)
    add_index(:profiles, :openid)
    add_index(:sessions, :session_id)
	add_index(:sessions, :updated_at)
  end

  def self.down
	remove_index(:documents, :doctitle)
    remove_index(:documents, :tags)
	remove_index(:questions, :question_info)
    remove_index(:questions, :tags)
    remove_index(:answers, :answercontent)
    remove_index(:events, :event_name)
    remove_index(:events, :event_place)
    remove_index(:comment_documents, :content)
	remove_index(:comment_events, :content)
    remove_index(:profiles, :firstname)
    remove_index(:profiles, :lastname)
	remove_index(:profiles, :email)
    remove_index(:profiles, :openid)
    remove_index(:sessions, :session_id)
	remove_index(:sessions, :updated_at)
  end
end
