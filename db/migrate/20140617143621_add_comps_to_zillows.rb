class AddCompsToZillows < ActiveRecord::Migration
  def change
		add_column :zillows, :related_0_zpid, :integer
		add_column :zillows, :related_0_address, :string
		add_column :zillows, :related_0_city, :string
		add_column :zillows, :related_0_state, :string
		add_column :zillows, :related_0_zip, :integer
		add_column :zillows, :related_0_latitude, :decimal
		add_column :zillows, :related_0_longitude, :decimal
		add_column :zillows, :related_0_valuationRange_low, :integer
		add_column :zillows, :related_0_valuationRange_high, :integer
		add_column :zillows, :related_0_zestimate, :integer
		add_column :zillows, :related_0_taxAssessmentYear, :integer
		add_column :zillows, :related_0_taxAssessment, :decimal
		add_column :zillows, :related_0_yearBuilt	, :integer
		add_column :zillows, :related_0_lotSizeSqFt, :integer
		add_column :zillows, :related_0_bathrooms, :integer
		add_column :zillows, :related_0_bedrooms, :decimal
		add_column :zillows, :related_0_lastSoldDate, :date
		add_column :zillows, :related_0_lastSoldPrice, :integer
  end
end
