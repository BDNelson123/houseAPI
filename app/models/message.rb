class Message
  include Mongoid::Document
  store_in collection: "messages"

  field :message, :type => String
  field :sender_id, :type => Integer
  field :receiver_id, :type => Integer
  field :thread_id, :type => Integer
  field :home_id, :type => Integer

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :message, presence: true
  validates :thread_id, presence: true
  validates :home_id, presence: true

  def self.thread_id(sender_id,receiver_id)
    thread = Message.any_of({:sender_id => sender_id, :receiver_id => receiver_id}, {:sender_id => receiver_id, :receiver_id => sender_id}).limit(1).first

    if thread
      return thread.thread_id
    else
      if Message.count < 1
        return 1
      else
        return Message.max(:thread_id) + 1
      end
    end
  end
end
