class User < ActiveRecord::Base
  has_secure_password

  validates_email_format_of :email
  validates :email, :presence => true
  validates_uniqueness_of :email
end
