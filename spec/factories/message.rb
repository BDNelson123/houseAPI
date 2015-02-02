require 'factory_girl'

FactoryGirl.define do
  factory :message do
    message "This is a test."
    sender_id 1
    receiver_id 2
    home_id 1
    thread_id 1
  end
end
