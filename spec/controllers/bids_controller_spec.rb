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

    it 'sends a list of bids (3) for a house' do
      FactoryGirl.create(:user, id: 1, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      FactoryGirl.create(:home, id: 1)
      FactoryGirl.create(:bid, user_id: 1, home_id: 1)
      FactoryGirl.create(:bid, user_id: 1, home_id: 1)
      FactoryGirl.create(:bid, user_id: 1, home_id: 1)

      get :show, id: 1

      expect(JSON.parse(response.body).length).to eq(3)
    end
  end

  describe "#create" do
    it "cannot create a bid in the database because a user is not logged in" do
      user = FactoryGirl.create(:user, id: 1, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      home = FactoryGirl.create(:home, id: 1)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => 1 }}.to change(Bid, :count).by(0)
    end

    it "cannot create a log record in the mongodb database because a user is not logged in" do
      user = FactoryGirl.create(:user, id: 1, auth_token: "D5zXdpU8a_7gmojN3k1bOg")
      home = FactoryGirl.create(:home, id: 1)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => 1 }}.to change(Log, :count).by(0)
    end

    it "creates a bid in the database when user is logged in" do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home, id: 1, user_id: user.id)

      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.auth_token)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => 1 }}.to change(Bid, :count).by(1)
    end

    it "creates a log in the mongodb database when user is logged in" do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home, id: 1, user_id: user.id)

      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.auth_token)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => 1 }}.to change(Log, :count).by(1)
    end
  end
end
