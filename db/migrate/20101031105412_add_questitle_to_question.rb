class AddQuestitleToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :questitle, :string
  end

  def self.down
    remove_column :questions, :questitle
  end
end
