class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :home
  has_many :image, :through => :home, :source => :images

  validates :user_id, :presence => true
  validates :home_id, :presence => true
  validates :price, :presence => true
  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0}

  scope :bid_show_attributes, -> { select('
    bids.id as bids_id,
    bids.user_id,
    bids.home_id,
    bids.price,
    bids.created_at,
    bids.updated_at,
    users.firstname,
    users.lastname,
    users.email'
    ) 
  }

  scope :bid_index_attributes, -> { select('
    homes.id as homes_id,
    homes.address,
    homes.address2,
    homes.city,
    homes.state,
    homes.zip,
    homes.price as homes_price,
    bids.price as bids_price,
    bids.created_at as bids_created_at,
    images.image,
    images.home_id'
    ) 
  }
end
