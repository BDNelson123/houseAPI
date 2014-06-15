class CreateZillows < ActiveRecord::Migration
  def change
    create_table :zillows do |t|
      t.integer :user_id
      t.integer :home_id
      t.integer :zpid
      t.integer :FIPScounty
      t.string :useCode
      t.integer :taxAssessmentYear
      t.decimal :taxAssessment
      t.integer :yearBuilt
      t.integer :lotSizeSqFt
      t.integer :finishedSqFt
      t.decimal :bathrooms
      t.integer :bedrooms
      t.date :lastSoldDate
      t.integer :lastSoldPrice
      t.integer :zestimate_amount
      t.integer :valuationRange_low
      t.integer :valuationRange_high

      t.timestamps
    end
  end
end
