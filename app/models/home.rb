class Home < ActiveRecord::Base
  belongs_to :user
  has_many :images, dependent: :destroy

  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zip, :presence => true
  validates :zip, numericality: { only_integer: true }
end
