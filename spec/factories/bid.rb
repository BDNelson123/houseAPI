require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :bid do
    user_id 1
    home_id 1
    price { Faker::Commerce.price }
  end
end
