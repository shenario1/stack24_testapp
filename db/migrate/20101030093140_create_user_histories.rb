class CreateUserHistories < ActiveRecord::Migration
  def self.up
    create_table :user_histories do |t|
      t.integer :profile_id
      t.string :page_url

      t.timestamps
    end
  end

  def self.down
    drop_table :user_histories
  end
end
