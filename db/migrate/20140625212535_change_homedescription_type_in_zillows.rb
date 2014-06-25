class ChangeHomedescriptionTypeInZillows < ActiveRecord::Migration
  def change
    change_column :zillows, :updated_homeDescription, :text
  end
end
