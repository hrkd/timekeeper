class AddIsExistBreaktimeToWork < ActiveRecord::Migration
  def change
    add_column :works, :is_exist_breaktime, :boolean
  end
end
