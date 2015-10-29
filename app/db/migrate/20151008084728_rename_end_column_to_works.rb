class RenameEndColumnToWorks < ActiveRecord::Migration
  def change
    rename_column :works, :end, :endtime
  end
end
