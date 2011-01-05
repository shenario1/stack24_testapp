class CreateCommentDocuments < ActiveRecord::Migration
  def self.up
    create_table :comment_documents do |t|
      t.integer :profile_id, :null => false
      t.string :content, :null => false, :default => ""
      t.integer :document_id, :null => false
      t.integer :rating, :default => 0
      t.integer :reportspam, :default => 0
      t.integer :points, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_documents
  end
end
