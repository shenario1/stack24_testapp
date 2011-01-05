class CreateFavouriteEvents < ActiveRecord::Migration
  def self.up
    create_table :favourite_events do |t|
      t.integer :profile_id
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :favourite_events
  end
end
