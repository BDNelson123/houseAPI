class AddImagesToZillows < ActiveRecord::Migration
  def change
    add_column :zillows, :updated_image_1, :string
    add_column :zillows, :updated_image_2, :string
    add_column :zillows, :updated_image_3, :string
    add_column :zillows, :updated_image_4, :string
    add_column :zillows, :updated_image_5, :string
  end
end
