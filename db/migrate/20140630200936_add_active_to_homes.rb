class AddActiveToHomes < ActiveRecord::Migration
  def change
    add_column :homes, :active, :boolean
  end
end
