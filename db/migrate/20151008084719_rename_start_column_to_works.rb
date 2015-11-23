class RenameStartColumnToWorks < ActiveRecord::Migration
  def change
    rename_column :works, :start, :starttime
  end
end
