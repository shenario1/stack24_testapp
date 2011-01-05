class AddAttachmentsDispPicToProfile < ActiveRecord::Migration
  def self.up

    add_column :profiles, :disp_pic_file_name, :string
    add_column :profiles, :disp_pic_content_type, :string
    add_column :profiles, :disp_pic_file_size, :integer
    add_column :profiles, :disp_pic_updated_at, :datetime

  end

  def self.down

    remove_column :profiles, :disp_pic_file_name
    remove_column :profiles, :disp_pic_content_type
    remove_column :profiles, :disp_pic_file_size
    remove_column :profiles, :disp_pic_updated_at

  end
end
