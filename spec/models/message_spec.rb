require 'spec_helper'

describe Message do
  context "validations" do
    context "presence = true" do
      context "individual attributes" do
        it "should return one validation error for sender_id" do
          message = Message.new(:sender_id => nil, :receiver_id => 2, :message => "test message", :thread_id => 1, :home_id => 1)
          message.should have(1).error_on(:sender_id)
          message.should have(0).error_on(:receiver_id)
          message.should have(0).error_on(:message)
          message.should have(0).error_on(:thread_id)
          message.should have(0).error_on(:home_id)
        end

        it "should return one validation error for receiver_id" do
          message = Message.new(:sender_id => 1, :receiver_id => nil, :message => "test message", :thread_id => 1, :home_id => 1)
          message.should have(0).error_on(:sender_id)
          message.should have(1).error_on(:receiver_id)
          message.should have(0).error_on(:message)
          message.should have(0).error_on(:thread_id)
          message.should have(0).error_on(:home_id)
        end

        it "should return one validation error for message" do
          message = Message.new(:sender_id => 1, :receiver_id => 1, :message => nil, :thread_id => 1, :home_id => 1)
          message.should have(0).error_on(:sender_id)
          message.should have(0).error_on(:receiver_id)
          message.should have(1).error_on(:message)
          message.should have(0).error_on(:thread_id)
          message.should have(0).error_on(:home_id)
        end

        it "should return one validation error for thread_id" do
          message = Message.new(:sender_id => 1, :receiver_id => 1, :message => "test message", :thread_id => nil, :home_id => 1)
          message.should have(0).error_on(:sender_id)
          message.should have(0).error_on(:receiver_id)
          message.should have(0).error_on(:message)
          message.should have(1).error_on(:thread_id)
          message.should have(0).error_on(:home_id)
        end

        it "should return one validation error for thread_id" do
          message = Message.new(:sender_id => 1, :receiver_id => 1, :message => "test message", :thread_id => 1, :home_id => nil)
          message.should have(0).error_on(:sender_id)
          message.should have(0).error_on(:receiver_id)
          message.should have(0).error_on(:message)
          message.should have(0).error_on(:thread_id)
          message.should have(1).error_on(:home_id)
        end
      end

      context "all attributes" do
        it "should return zero validation errors as all five attributes are present" do
          message = Message.new(:sender_id => 1, :receiver_id => 2, :message => "test message", :thread_id => 1, :home_id => 1)
          message.should have(0).error_on(:sender_id)
          message.should have(0).error_on(:receiver_id)
          message.should have(0).error_on(:message)
          message.should have(0).error_on(:thread_id)
          message.should have(0).error_on(:home_id)
        end

        it "should return five validation errors as all five attributes are nil" do
          message = Message.new(:sender_id => nil, :receiver_id => nil, :message => nil, :thread_id => nil, :home_id => nil)
          message.should have(1).error_on(:sender_id)
          message.should have(1).error_on(:receiver_id)
          message.should have(1).error_on(:message)
          message.should have(1).error_on(:thread_id)
          message.should have(1).error_on(:home_id)
        end
      end
    end
  end
end
