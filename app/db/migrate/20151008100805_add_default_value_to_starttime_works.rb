class AddDefaultValueToStarttimeWorks < ActiveRecord::Migration
  def change
    change_column :works, :starttime, :datetime, :default => nil
  end
end
