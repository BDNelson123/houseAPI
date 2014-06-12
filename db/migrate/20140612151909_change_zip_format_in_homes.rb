class ChangeZipFormatInHomes < ActiveRecord::Migration
  def change
    remove_column :homes, :zip
    add_column :homes, :zip, :integer
  end
end
