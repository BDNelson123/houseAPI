require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :image do
    user_id 1
    home_id 1
    klass 'user' 
    primary true
    image { fixture_file_upload(Rails.root.join('spec', 'photos', 'test.jpg'), 'image/jpg') }
  end
end
