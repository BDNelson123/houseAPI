require 'spec_helper'

describe Bid do
  context "validations" do
    context "presence = true" do
      it "should return one validation error for price" do
        bid = Bid.new(:price => nil, :user_id => 1, :home_id => 1)
        bid.should have(3).error_on(:price)
        bid.should have(0).error_on(:user_id)
        bid.should have(0).error_on(:home_id)
      end

      it "should return one validation error for user_id" do
        bid = Bid.new(:price => 1000, :user_id => nil, :home_id => 1)
        bid.should have(0).error_on(:price)
        bid.should have(1).error_on(:user_id)
        bid.should have(0).error_on(:home_id)
      end

      it "should return one validation error for home_id" do
        bid = Bid.new(:price => 1000, :user_id => 1, :home_id => nil)
        bid.should have(0).error_on(:price)
        bid.should have(0).error_on(:user_id)
        bid.should have(1).error_on(:home_id)
      end
    end

    context "price validations" do
      # Price is invalid
      # Price must be greater than 0
      it "should have two validation errors if the integer is negative" do
        bid = Bid.new(:price => -100, :user_id => 1, :home_id => 1)
        bid.should have(2).error_on(:price)
      end

      # Price is not a number
      it "should have one validation errors if the integer is a string" do
        bid = Bid.new(:price => "test", :user_id => 1, :home_id => 1)
        bid.should have(1).error_on(:price)
      end
    end
  end
end
