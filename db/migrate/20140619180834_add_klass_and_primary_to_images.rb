class AddKlassAndPrimaryToImages < ActiveRecord::Migration
  def change
		add_column :images, :klass, :string
		add_column :images, :primary, :boolean
  end
end
