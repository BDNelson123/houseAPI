class User < ActiveRecord::Base
  has_secure_password

  validates_email_format_of :email
  validates :email, :presence => true
  validates_uniqueness_of :email
  validates_presence_of :password_digest, :on => :create 

  def self.auth_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      return random_token unless User.exists?(auth_token: random_token)
    end
  end
end
