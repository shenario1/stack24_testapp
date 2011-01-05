class AddAnswercountToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :answercount, :integer, :default => 0
  end

  def self.down
    remove_column :questions, :answercount
  end
end
