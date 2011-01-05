class CreateEventRatings < ActiveRecord::Migration
  def self.up
    create_table :event_ratings do |t|
      t.integer :profile_id, :null => false
      t.integer :event_id, :null => false
      t.integer :user_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :event_ratings
  end
end
