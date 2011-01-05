class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :profile_id, :null => false
      t.string :question_info, :null => false, :default => ""
      t.string :tags, :null => false, :default => ""
      t.integer :rating, :default => 0
      t.integer :reportspam, :default => 0
      t.integer :points, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
