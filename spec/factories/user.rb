require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    password 'EDSW94edsw'
    password_confirmation 'EDSW94edsw'
    auth_token SecureRandom.urlsafe_base64(nil, false)
  end
end
