class CreateCommentEventRatings < ActiveRecord::Migration
  def self.up
    create_table :comment_event_ratings do |t|
      t.integer :profile_id
      t.integer :comment_event_id
      t.integer :user_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_event_ratings
  end
end
