class AddDefaultValueToActiveHomes < ActiveRecord::Migration
  def change
    change_column :homes, :active, :boolean, :default => true
  end
end
