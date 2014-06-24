class Message
  include Mongoid::Document
  store_in collection: "messages"

  field :message, :type => String
  field :sender_id, :type => Integer
  field :receiver_id, :type => Integer
  field :home_id, :type => Integer

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :home_id, presence: true
  validates :message, presence: true
end
