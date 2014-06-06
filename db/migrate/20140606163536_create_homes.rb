class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.integer :user_id
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
