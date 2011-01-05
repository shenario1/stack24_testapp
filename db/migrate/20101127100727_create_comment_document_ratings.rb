class CreateCommentDocumentRatings < ActiveRecord::Migration
  def self.up
    create_table :comment_document_ratings do |t|
      t.integer :profile_id
      t.integer :comment_document_id
      t.integer :user_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_document_ratings
  end
end
