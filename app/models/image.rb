class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :house

  validates :user_id, :presence => true
  validates :home_id, :presence => true
  validates :image, :presence => true

  mount_uploader :image, ImageUploader
end
