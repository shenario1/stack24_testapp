class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :profile_id, :null => false
      t.string :answercontent, :null => false, :default => ""
      t.integer :question_id, :null => false
      t.integer :rating, :default => 0
      t.integer :reportspam, :default => 0
      t.integer :points, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
