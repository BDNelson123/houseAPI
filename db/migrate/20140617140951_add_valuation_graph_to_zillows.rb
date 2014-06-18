class AddValuationGraphToZillows < ActiveRecord::Migration
  def change
    add_column :zillows, :valuationGraph_1year, :string
    add_column :zillows, :valuationGraph_5years, :string
  end
end
