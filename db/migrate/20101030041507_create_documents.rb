class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :profile_id, :null => false
      t.string :doctitle, :null => false, :default => ""
      t.string :tags, :null => false, :default => ""
      t.integer :downloadcount, :default => 0
      t.integer :viewcount, :default => 0
      t.integer :rating, :default => 0
      t.integer :reportspam, :default => 0
      t.integer :points, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
