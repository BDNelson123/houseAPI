class AddDemographicsToZillows < ActiveRecord::Migration
  def change
		add_column :zillows, :demographics_medianCondoValue, :string
		add_column :zillows, :demographics_medianHomeValue, :string
		add_column :zillows, :demographics_dollarsPerSquareFeet, :string
		add_column :zillows, :demographics_zillowHomeValueIndexDistribution, :string
		add_column :zillows, :demographics_homeType, :string
		add_column :zillows, :demographics_ownersVsRenters, :string
		add_column :zillows, :demographics_homeSizeInSquareFeet, :string
		add_column :zillows, :demographics_yearBuilt, :string
		add_column :zillows, :demographics_zillowHomeValueIndex, :integer
		add_column :zillows, :demographics_medianSingleFamilyHomeValue, :integer
		add_column :zillows, :demographics_medianCondoValueAmount, :integer
		add_column :zillows, :demographics_median2BedroomHomeValue, :integer
		add_column :zillows, :demographics_median3BedroomHomeValue, :integer
		add_column :zillows, :demographics_median4BedroomHomeValue, :integer
		add_column :zillows, :demographics_percentHomesDecreasing, :decimal
		add_column :zillows, :demographics_percentListingPriceReduction, :decimal
		add_column :zillows, :demographics_medianListPricePerSqFt, :integer
		add_column :zillows, :demographics_medianListPrice, :integer
		add_column :zillows, :demographics_medianSalePrice, :integer
		add_column :zillows, :demographics_medianValuePerSqFt, :integer
		add_column :zillows, :demographics_propertyTax, :integer
  end
end
