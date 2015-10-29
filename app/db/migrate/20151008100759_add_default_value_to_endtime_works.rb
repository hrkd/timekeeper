class AddDefaultValueToEndtimeWorks < ActiveRecord::Migration
  def change
    change_column :works, :endtime, :datetime, :default => nil
  end
end
