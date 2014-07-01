require 'spec_helper'
include ActionDispatch::TestProcess

describe HomesController do
  before(:each) do
    User.delete_all
    Home.delete_all
    Zillow.delete_all
    Image.delete_all

    user1 = FactoryGirl.create(:user, id: 1, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
    user2 = FactoryGirl.create(:user, id: 2, auth_token: "D5zXdpU8a_7gmojN3k1333")

    home1 = FactoryGirl.create(:home, id: 3, user_id: 1)
    home2 = FactoryGirl.create(:home, id: 4, user_id: 2)

    image1 = FactoryGirl.create(:image, id: 4, user_id: 1, home_id: 3)
    image2 = FactoryGirl.create(:image, id: 5, user_id: 2, home_id: 4)

    zillow1 = FactoryGirl.create(:zillow, id: 6, user_id: 1, home_id: 3)
    zillow2 = FactoryGirl.create(:zillow, id: 7, user_id: 2, home_id: 4)
  end

  describe "index" do
    it "should return 1 total row" do
      response = Home.home_joins.home_attributes.where(:user_id => 1, :active => true).group("homes.id, zillows.id")
      expect(response.length).to eq(1)
    end

    it "should return the id of the home" do
      response = Home.home_joins.home_attributes.where(:user_id => 1, :active => true).group("homes.id, zillows.id").to_json
      parsed_json = ActiveSupport::JSON.decode(response)
      expect(parsed_json[0]['id']).to eq(3)
    end

    it "should return the id of the image" do
      response = Home.home_joins.home_attributes.where(:user_id => 1, :active => true).group("homes.id, zillows.id").to_json
      parsed_json = ActiveSupport::JSON.decode(response)
      expect(parsed_json[0]['images'][0]['id']).to eq(4)
    end

    it "should return the url of the image" do
      response = Home.home_joins.home_attributes.where(:user_id => 1, :active => true).group("homes.id, zillows.id").to_json
      parsed_json = ActiveSupport::JSON.decode(response)
      expect(parsed_json[0]['images'][0]['image']['url']).to eq('/uploads/image/image/4/test.jpg')
    end
  end
end
