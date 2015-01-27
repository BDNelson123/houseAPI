require 'spec_helper'

describe Home do
  context "validations" do
    context "presence = true" do
      it "should return one validation error for user_id" do
        home = Home.new(:user_id => nil, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => 10000, :active => true)
        home.should have(1).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(0).error_on(:active)
      end

      it "should return one validation error for address" do
        home = Home.new(:user_id => 1, :address => nil, :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => 10000, :active => true)
        home.should have(0).error_on(:user_id)
        home.should have(1).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(0).error_on(:active)
      end

      it "should return zero validation errors for address2 - it can be nil" do
        home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => 10000, :active => true)
        home.should have(0).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(0).error_on(:active)
      end

      it "should return one validation error for city" do
        home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => nil, :state => "TX", :zip => 78749, :price => 10000, :active => true)
        home.should have(0).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(1).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(0).error_on(:active)
      end

      it "should return one validation error for state" do
        home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => nil, :zip => 78749, :price => 10000, :active => true)
        home.should have(0).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(1).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(0).error_on(:active)
      end

      it "should return two validation errors for zip" do
        # zip cant be blank and zip is not a number
        home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => nil, :price => 10000, :active => true)
        home.should have(0).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(2).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(0).error_on(:active)
      end

      it "should return one validation error for price" do
        # Price can't be blank, Price is invalid, and Price is not a number
        home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => nil, :active => true)
        home.should have(0).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(3).error_on(:price)
        home.should have(0).error_on(:active)
      end

      it "should return one validation error for price" do
        home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => 10000, :active => nil)
        home.should have(0).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(1).error_on(:active)
      end
    end

    context "non presence validations for zip and price" do
      context "zip validations" do
        it "should return one validation error for zip if it contains a letter" do
          home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => "78749a", :price => 10000, :active => true)
          home.should have(1).error_on(:zip)
        end
      end

      context "price validations" do
        it "should return one validation error for price if it contains a letter" do
          home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => "10000a", :active => true)
          home.should have(1).error_on(:price)
        end

        it "should return one validation error for price if it contains a $" do
          home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => "$10000", :active => true)
          home.should have(1).error_on(:price)
        end

        it "should return one validation error for price if it contains more than two decimal places" do
          home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => "10000.444", :active => true)
          home.should have(1).error_on(:price)
        end

        it "should return one validation error for price if it is negative" do
          home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => -1000, :active => true)
          home.should have(1).error_on(:price)
        end

        it "should return zero validation errors for price if it has two decimal places" do
          home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => "10000.44", :active => true)
          home.should have(0).error_on(:price)
        end
      end
    end

    context "no validation errors" do
      it "should return zero validation errors" do
        home = Home.new(:user_id => 1, :address => "7615 Navarro Pl.", :address2 => nil, :city => "Austin", :state => "TX", :zip => 78749, :price => "10000.44", :active => true)
        home.should have(0).error_on(:user_id)
        home.should have(0).error_on(:address)
        home.should have(0).error_on(:address2)
        home.should have(0).error_on(:city)
        home.should have(0).error_on(:state)
        home.should have(0).error_on(:zip)
        home.should have(0).error_on(:price)
        home.should have(0).error_on(:active)
      end
    end
  end
end
