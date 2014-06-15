class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :user_id
      t.integer :home_id
      t.decimal :price
      t.timestamps
    end
  end
end
