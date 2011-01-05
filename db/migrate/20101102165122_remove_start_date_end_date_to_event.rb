class RemoveStartDateEndDateToEvent < ActiveRecord::Migration
  def self.up
    remove_column :events, :start_date
    remove_column :events, :end_date
  end

  def self.down
    add_column :events, :end_date, :date
    add_column :events, :start_date, :date
  end
end
