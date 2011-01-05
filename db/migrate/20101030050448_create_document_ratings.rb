class CreateDocumentRatings < ActiveRecord::Migration
  def self.up
    create_table :document_ratings do |t|
      t.integer :profile_id, :null => false
      t.integer :document_id, :null => false
      t.integer :user_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :document_ratings
  end
end
