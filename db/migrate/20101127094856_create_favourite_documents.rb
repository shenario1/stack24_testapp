class CreateFavouriteDocuments < ActiveRecord::Migration
  def self.up
    create_table :favourite_documents do |t|
      t.integer :profile_id
      t.integer :document_id

      t.timestamps
    end
  end

  def self.down
    drop_table :favourite_documents
  end
end
