class ChangeFipscountyToLowercase < ActiveRecord::Migration
  def change
    rename_column :zillows, :FIPScounty, :fipsCounty
  end
end
