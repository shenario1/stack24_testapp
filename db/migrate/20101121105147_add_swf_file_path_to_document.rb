class AddSwfFilePathToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :swf_file_path, :string
  end

  def self.down
    remove_column :documents, :swf_file_path
  end
end
