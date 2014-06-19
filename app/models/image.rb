class Image < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :house, dependent: :destroy

  validates :user_id, :presence => true
  validates :image, :presence => true
  validates :klass, :presence => true

  mount_uploader :image, ImageUploader
end
