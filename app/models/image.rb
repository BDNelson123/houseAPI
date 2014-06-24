class Image < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :house, dependent: :destroy

  validates :user_id, :presence => true
  validates :image, :presence => true
  validates :klass, :presence => true

  mount_uploader :image, ImageUploader

  def self.query(params)
    if params[:primary] == 'true'
      where(:klass => params[:klass], Common.klass(params[:klass]) => params[:id], :primary => true).first
    else
      where(:klass => params[:klass], Common.klass(params[:klass]) => params[:id])
    end
  end
end
