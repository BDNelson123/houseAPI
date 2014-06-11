class ChangeHomeIdFormatInImages < ActiveRecord::Migration
  def change
    remove_column :images, :home_id
    add_column :images, :home_id, :integer
  end
end
