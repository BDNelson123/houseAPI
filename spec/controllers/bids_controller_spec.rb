require 'spec_helper'

describe BidsController, :type => :api do
  describe "#show" do
    it 'sends a list of bids (only 1) for a house' do
      user = FactoryGirl.create(:user, id: 1, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      home = FactoryGirl.create(:home, id: 1)
      bid = FactoryGirl.create(:bid, id: 1, user_id: 1, home_id: 1)

      get :show, id: 1

      expect(JSON.parse(response.body).length).to eq(1)
      expect(JSON.parse(response.body)[0]["id"]).to eq(bid.id)
      expect(JSON.parse(response.body)[0]["price"].to_f).to eq(bid.price.to_f)
    end

    it 'sends a list of bids (5) for a house' do
      FactoryGirl.create(:user, id: 1, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      FactoryGirl.create(:home, id: 1)
      FactoryGirl.create(:bid, user_id: 1, home_id: 1)
      FactoryGirl.create(:bid, user_id: 1, home_id: 1)
      FactoryGirl.create(:bid, user_id: 1, home_id: 1)

      get :show, id: 1
      expect(JSON.parse(response.body).length).to eq(3)
    end
  end
end
