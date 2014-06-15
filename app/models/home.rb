class Home < ActiveRecord::Base
  belongs_to :user
  has_many :images, dependent: :destroy
  has_many :bids

  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zip, :presence => true
  validates :zip, numericality: { only_integer: true }
  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0}
end
