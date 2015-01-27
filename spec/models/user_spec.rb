require 'spec_helper'

describe User do
  context "validations" do
    context "no validation errors" do
      it "should return zero validation errors" do
        user = User.new(:firstname => "Eric", :lastname => "Draven", :email => "eric.daven@gmail.com", :password => "testing123")
        user.should have(0).error_on(:firstname)
        user.should have(0).error_on(:lastname)
        user.should have(0).error_on(:email)
        user.should have(0).error_on(:password)
        user.should have(0).error_on(:password_digest)
      end
    end

    context "email present" do
      # Email can't be blank and Email does not appear to be valid
      it "should return two validation errors if email is not present" do
        user = User.new(:firstname => "Eric", :lastname => "Draven", :email => nil, :password => "testing123")
        user.should have(0).error_on(:firstname)
        user.should have(0).error_on(:lastname)
        user.should have(2).error_on(:email)
        user.should have(0).error_on(:password)
        user.should have(0).error_on(:password_digest)
      end
    end

    context "password present" do
      # Password can't be blank and Password digest can't be blank
      it "should return two validation errors if password is not present" do
        user = User.new(:firstname => "Eric", :lastname => "Draven", :email => "eric.daven@gmail.com", :password => nil)
        user.should have(0).error_on(:firstname)
        user.should have(0).error_on(:lastname)
        user.should have(0).error_on(:email)
        user.should have(1).error_on(:password)
        user.should have(1).error_on(:password_digest)
      end
    end

    context "valid email" do
      it "should return one validation error if email is not valid" do
        user = User.new(:firstname => "Eric", :lastname => "Draven", :email => "bart.com", :password => "testing123")
        user.should have(0).error_on(:firstname)
        user.should have(0).error_on(:lastname)
        user.should have(1).error_on(:email)
        user.should have(0).error_on(:password)
        user.should have(0).error_on(:password_digest)
      end
    end

    context "email uniqueness" do
      it "should return one validation error if email is not unique" do
        FactoryGirl.create(:user, :id => 1, :email => "eric.draven@gmail.com").should be_valid
        FactoryGirl.build(:user, :id => 2, :email => "eric.draven@gmail.com").should_not be_valid
      end

      it "should return zero validation errors if email is unique" do
        FactoryGirl.create(:user, :id => 1, :email => "eric.draven@gmail.com").should be_valid
        FactoryGirl.build(:user, :id => 2, :email => "shelly.webster@gmail.com").should be_valid
      end
    end
  end

  describe "user_id" do
    it "should return the user id when given the user token" do
      user = FactoryGirl.create(:user, id: 100, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      expect(User.user_id(user.auth_token)).to eq(100)
    end

    it "should return the user id when given the user token" do
      user = FactoryGirl.create(:user, id: 100, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      expect(User.user_id(user.auth_token)).to_not eq(101)
    end
  end

  describe "auth_token" do
    it "should return a unique token for every user" do
      user1 = FactoryGirl.create(:user, id: 100, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      expect(User.auth_token).to_not eq("D5zXdpU8a_7gmojN3k1bOg")
    end
  end
end
