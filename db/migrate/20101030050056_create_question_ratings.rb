class CreateQuestionRatings < ActiveRecord::Migration
  def self.up
    create_table :question_ratings do |t|
      t.integer :profile_id, :null => false
      t.integer :question_id, :null => false
      t.integer :user_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :question_ratings
  end
end
