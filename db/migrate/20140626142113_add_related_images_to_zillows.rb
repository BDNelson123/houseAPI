class AddRelatedImagesToZillows < ActiveRecord::Migration
  def change
    add_column :zillows, :related_0_image_1, :string
    add_column :zillows, :related_0_image_2, :string
    add_column :zillows, :related_0_image_3, :string
    add_column :zillows, :related_0_image_4, :string
    add_column :zillows, :related_0_image_5, :string
    add_column :zillows, :related_1_image_1, :string
    add_column :zillows, :related_1_image_2, :string
    add_column :zillows, :related_1_image_3, :string
    add_column :zillows, :related_1_image_4, :string
    add_column :zillows, :related_1_image_5, :string
    add_column :zillows, :related_2_image_1, :string
    add_column :zillows, :related_2_image_2, :string
    add_column :zillows, :related_2_image_3, :string
    add_column :zillows, :related_2_image_4, :string
    add_column :zillows, :related_2_image_5, :string
  end
end
