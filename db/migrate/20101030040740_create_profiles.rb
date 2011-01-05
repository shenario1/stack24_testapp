class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.string :email, :null => false
      t.date :dob
      t.integer :sex
      t.integer :status
      t.string :institute, :default => ""
      t.string :city, :default => ""
      t.string :state, :default => ""
      t.binary :disp_pic
      t.string :openid, :null => false
	  t.integer :points, :default => 0
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
