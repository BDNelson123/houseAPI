class Home < ActiveRecord::Base
  belongs_to :user
  has_many :images, dependent: :destroy

  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zip, :presence => true

  def self.home_images
    sql = "SELECT home.*,array_agg(image.image) AS images FROM homes home LEFT JOIN images image ON home.id = image.home_id GROUP BY home.id"
    components_array = ActiveRecord::Base.connection.execute(sql)
    return components_array
  end
end
