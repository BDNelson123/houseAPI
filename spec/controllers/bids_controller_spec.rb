require 'spec_helper'

describe BidsController, :type => :api do
  # action: show
  describe "#show" do
    it 'sends a list of bids (only 1) for a house' do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home)
      bid = FactoryGirl.create(:bid, user_id: user.id, home_id: home.id)
      get :show, id: home.id

      expect(JSON.parse(response.body).length).to eq(1)
      expect(JSON.parse(response.body)[0]["bids_id"]).to eq(bid.id)
      expect(JSON.parse(response.body)[0]["price"].to_f).to eq(bid.price.to_f)
      expect(response.status).to eq(200)
    end

    it 'sends a list of bids (3) for a house' do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home)
      bid_1 = FactoryGirl.create(:bid, user_id: user.id, home_id: home.id)
      bid_2 = FactoryGirl.create(:bid, user_id: user.id, home_id: home.id)
      bid_3 = FactoryGirl.create(:bid, user_id: user.id, home_id: home.id)
      get :show, id: home.id

      expect(JSON.parse(response.body).length).to eq(3)
      expect(response.status).to eq(200)
    end
  end

  # action: create
  describe "#create" do
    it "cannot create a bid in the database because a user is not logged in" do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => home.id }}.to change(Bid, :count).by(0)
      expect(response.status).to eq(401)
    end

    it "cannot create a log record in the mongodb database because a user is not logged in" do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => home.id }}.to change(Log, :count).by(0)
      expect(response.status).to eq(401)
    end

    it "creates a bid in the database when user is logged in" do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home, user_id: user.id)
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.auth_token)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => home.id }}.to change(Bid, :count).by(1)
      expect(response.status).to eq(201)
    end

    it "creates a log in the mongodb database when user is logged in" do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home, user_id: user.id)
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.auth_token)

      expect {post :create, {'bid' => {:price => 100}, 'home_id' => home.id }}.to change(Log, :count).by(1)
      expect(response.status).to eq(201)
    end
  end

  #action: index
  describe "#index" do
    it "" do
      user = FactoryGirl.create(:user)
      home = FactoryGirl.create(:home)
      bid_1 = FactoryGirl.create(:bid, user_id: user.id, home_id: home.id)
      bid_2 = FactoryGirl.create(:bid, user_id: user.id, home_id: home.id)
      bid_3 = FactoryGirl.create(:bid, user_id: user.id, home_id: home.id)
      get :index, user_id: user.id

      expect(JSON.parse(response.body).length).to eq(3)
      expect(JSON.parse(response.body)[0]["bids_price"].to_f).to eq(bid_3.price.to_f)
      expect(JSON.parse(response.body)[1]["bids_price"].to_f).to eq(bid_2.price.to_f)
      expect(JSON.parse(response.body)[2]["bids_price"].to_f).to eq(bid_1.price.to_f)
      expect(JSON.parse(response.body)[0]["address"]).to eq(home.address)
      expect(JSON.parse(response.body)[1]["address"]).to eq(home.address)
      expect(JSON.parse(response.body)[2]["address"]).to eq(home.address)
      expect(response.status).to eq(200)
    end
  end
end
