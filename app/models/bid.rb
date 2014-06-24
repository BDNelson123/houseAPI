class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :home

  validates :user_id, :presence => true
  validates :home_id, :presence => true
  validates :price, :presence => true
  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0}
end
