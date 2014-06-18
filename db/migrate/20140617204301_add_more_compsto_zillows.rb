class AddMoreCompstoZillows < ActiveRecord::Migration
  def change
		add_column :zillows, :related_1_zpid, :integer
		add_column :zillows, :related_1_address, :string
		add_column :zillows, :related_1_city, :string
		add_column :zillows, :related_1_state, :string
		add_column :zillows, :related_1_zip, :integer
		add_column :zillows, :related_1_latitude, :decimal
		add_column :zillows, :related_1_longitude, :decimal
		add_column :zillows, :related_1_valuationRange_low, :integer
		add_column :zillows, :related_1_valuationRange_high, :integer
		add_column :zillows, :related_1_zestimate, :integer
		add_column :zillows, :related_1_taxAssessmentYear, :integer
		add_column :zillows, :related_1_taxAssessment, :decimal
		add_column :zillows, :related_1_yearBuilt	, :integer
		add_column :zillows, :related_1_lotSizeSqFt, :integer
		add_column :zillows, :related_1_bathrooms, :integer
		add_column :zillows, :related_1_bedrooms, :decimal
		add_column :zillows, :related_1_lastSoldDate, :date
		add_column :zillows, :related_1_lastSoldPrice, :integer

		add_column :zillows, :related_2_zpid, :integer
		add_column :zillows, :related_2_address, :string
		add_column :zillows, :related_2_city, :string
		add_column :zillows, :related_2_state, :string
		add_column :zillows, :related_2_zip, :integer
		add_column :zillows, :related_2_latitude, :decimal
		add_column :zillows, :related_2_longitude, :decimal
		add_column :zillows, :related_2_valuationRange_low, :integer
		add_column :zillows, :related_2_valuationRange_high, :integer
		add_column :zillows, :related_2_zestimate, :integer
		add_column :zillows, :related_2_taxAssessmentYear, :integer
		add_column :zillows, :related_2_taxAssessment, :decimal
		add_column :zillows, :related_2_yearBuilt	, :integer
		add_column :zillows, :related_2_lotSizeSqFt, :integer
		add_column :zillows, :related_2_bathrooms, :integer
		add_column :zillows, :related_2_bedrooms, :decimal
		add_column :zillows, :related_2_lastSoldDate, :date
		add_column :zillows, :related_2_lastSoldPrice, :integer
  end
end
