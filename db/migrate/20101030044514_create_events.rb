class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :profile_id, :null => false
      t.string :event_name, :null => false, :default => ""
      t.date :start_date, :null => false
      t.date :end_date
      t.string :event_place, :default => ""
      t.string :description, :default => ""
      t.string :website
      t.integer :rating, :default => 0
      t.integer :reportspam, :default => 0
      t.integer :points, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
