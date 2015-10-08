class AddTaskIdToWorks < ActiveRecord::Migration
  def change
    add_column :works, :task_id, :integer
  end
end
