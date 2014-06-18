class AddRegionToZillows < ActiveRecord::Migration
  def change
		add_column :zillows, :region_id, :integer
		add_column :zillows, :region_name, :string
  end
end
