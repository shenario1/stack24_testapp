class RemoveDispPicFromProfile < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :disp_pic
  end

  def self.down
    add_column :profiles, :disp_pic, :binary
  end
end
