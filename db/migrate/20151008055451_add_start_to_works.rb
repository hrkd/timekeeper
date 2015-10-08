class AddStartToWorks < ActiveRecord::Migration
  def change
    add_column :works, :start, :datetime
  end
end
