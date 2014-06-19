class AlterTypesForBedroomsAndBathroomsRelatedToZillows < ActiveRecord::Migration
  def change
    change_column :zillows, :related_0_bedrooms, :integer
    change_column :zillows, :related_0_bathrooms, :decimal
    change_column :zillows, :related_1_bedrooms, :integer
    change_column :zillows, :related_1_bathrooms, :decimal
    change_column :zillows, :related_2_bedrooms, :integer
    change_column :zillows, :related_2_bathrooms, :decimal
  end
end
