class AddRoofExteriormatertialHeatingsystemCoolingsystemAppliancesFloorcoveringRoomsArchitectureToZillows < ActiveRecord::Migration
  def change
    add_column :zillows, :updated_roof, :string
    add_column :zillows, :updated_exteriorMaterial, :string
    add_column :zillows, :updated_heatingSystem, :string
    add_column :zillows, :updated_coolingSystem, :string
    add_column :zillows, :updated_appliances, :string
    add_column :zillows, :updated_floorCovering, :string
    add_column :zillows, :updated_rooms, :string
    add_column :zillows, :updated_architecture, :string
    add_column :zillows, :updated_homeDescription, :string
  end
end
