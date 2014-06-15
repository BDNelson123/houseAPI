class AddPriceToHomes < ActiveRecord::Migration
  def change
    add_column :homes, :price, :decimal
  end
end
