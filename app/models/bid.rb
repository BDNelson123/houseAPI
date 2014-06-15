class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :home

  validates :user_id, :presence => true
  validates :home_id, :presence => true
  validates :bid, :presence => true
  validates :bid, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}
end
