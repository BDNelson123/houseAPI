require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :log do
    user_id 1
    type "home"
    action "create"
    date Time.now
    home_id 1
    address Faker::Address.street_address
    address2 Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state_abbr
    zip 78749
    price 100000
    active true
  end
end
