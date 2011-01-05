class RemoveFirstnameLastnameFromProfile < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :firstname
    remove_column :profiles, :lastname
	add_column :profiles, :name, :string
  end

  def self.down
    add_column :profiles, :lastname, :string
    add_column :profiles, :firstname, :string
	remove_column :profiles, :name, :string
  end
end
