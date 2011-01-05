class CreateFollowQuestions < ActiveRecord::Migration
  def self.up
    create_table :follow_questions do |t|
      t.integer :question_id, :null => false
      t.integer :profile_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :follow_questions
  end
end
