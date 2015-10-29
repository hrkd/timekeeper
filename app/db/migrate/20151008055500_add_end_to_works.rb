class AddEndToWorks < ActiveRecord::Migration
  def change
    add_column :works, :end, :datetime
  end
end
