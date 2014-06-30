require 'spec_helper'

describe User do
  before(:each) do
    User.delete_all
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
