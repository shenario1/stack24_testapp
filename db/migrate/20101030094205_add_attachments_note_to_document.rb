class AddAttachmentsNoteToDocument < ActiveRecord::Migration
  def self.up

    add_column :documents, :note_file_name, :string
    add_column :documents, :note_content_type, :string
    add_column :documents, :note_file_size, :integer
    add_column :documents, :note_updated_at, :datetime

  end

  def self.down

    remove_column :documents, :note_file_name
    remove_column :documents, :note_content_type
    remove_column :documents, :note_file_size
    remove_column :documents, :note_updated_at

  end
end
