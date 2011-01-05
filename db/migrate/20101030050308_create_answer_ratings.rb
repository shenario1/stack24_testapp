class CreateAnswerRatings < ActiveRecord::Migration
  def self.up
    create_table :answer_ratings do |t|
      t.integer :profile_id, :null => false
      t.integer :answer_id, :null => false
      t.integer :user_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_ratings
  end
end
