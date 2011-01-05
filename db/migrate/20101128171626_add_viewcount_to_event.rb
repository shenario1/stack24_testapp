class AddViewcountToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :viewcount, :integer
  end

  def self.down
    remove_column :events, :viewcount
  end
end
