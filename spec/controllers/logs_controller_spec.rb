require 'spec_helper'

describe LogsController do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)

    # first user log records
    home_id_1 = 1
    params_1 = { :address => "7615 Navarro Pl.", :address2 => "#765", :city => "Austin", :state => "TX", :zip => 78749, :price => 10000 }
    Log.home_create(@user.id,home_id_1,params_1)

    home_id_2 = 2
    params_2 = { :address => "2517 53rd St.", :address2 => nil, :city => "Lubbock", :state => "TX", :zip => 79423, :price => 25000 }
    Log.home_create(@user.id,home_id_2,params_2)

    @home = FactoryGirl.create(:home)
    Log.home_update(@user.id,@home)

    bid_create_params = { :bid => { :price => 150000 } }
    Log.bid_create(@user.id,bid_create_params,@home)

    # second user log records
    home_id_3 = 3
    params_3 = { :address => "300 Bowie St.", :address2 => "Apt 1707", :city => "Austin", :state => "TX", :zip => 78703, :price => 50000 }
    Log.home_create(@user2.id,home_id_3,params_3)
  end

  # SHOW action tests
  describe "#show" do
    context "user authentication" do
      it "should return a response of 200 if logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @user.id }
        expect(response.status).to eq(200)
      end

      it "should return a response of 200 if NOT logged in" do
        get :show, { 'id' => @user.id }
        expect(response.status).to eq(200)
      end
    end

    context "correct number of records returned" do
      it "should return two records for the first user" do
        get :show, { 'id' => @user.id }
        expect(JSON.parse(response.body).length).to eq(4)
      end

      it "should return one record for the second user" do
        get :show, { 'id' => @user2.id }
        expect(JSON.parse(response.body).length).to eq(1)
      end
    end

    context "correct attributes" do
      context "first user" do
        it "should return the correct value for users home" do
          get :show, { 'id' => @user.id }
          expect(JSON.parse(response.body)[0]["home_address"]).to eq(@home.address)
        end

        it "should return the correct value for users first record" do
          get :show, { 'id' => @user.id }
          expect(JSON.parse(response.body)[0]["type"]).to eq("bid")
          expect(JSON.parse(response.body)[0]["action"]).to eq("create")
        end

        it "should return the correct value for users second record" do
          get :show, { 'id' => @user.id }
          expect(JSON.parse(response.body)[1]["type"]).to eq("home")
          expect(JSON.parse(response.body)[1]["action"]).to eq("update")
          expect(JSON.parse(response.body)[1]["address"]).to eq(@home.address)
        end

        it "should return the correct value for users third record" do
          get :show, { 'id' => @user.id }
          expect(JSON.parse(response.body)[2]["type"]).to eq("home")
          expect(JSON.parse(response.body)[2]["action"]).to eq("create")
          expect(JSON.parse(response.body)[2]["address"]).to eq("2517 53rd St.")
        end

        it "should return the correct value for users fourth record" do
          get :show, { 'id' => @user.id }
          expect(JSON.parse(response.body)[3]["type"]).to eq("home")
          expect(JSON.parse(response.body)[3]["action"]).to eq("create")
          expect(JSON.parse(response.body)[3]["address"]).to eq("7615 Navarro Pl.")
        end
      end

      context "second user" do
        it "should return the correct value for second users first record type" do
          get :show, { 'id' => @user2.id }
          expect(JSON.parse(response.body)[0]["type"]).to eq("home")
          expect(JSON.parse(response.body)[0]["action"]).to eq("create")
          expect(JSON.parse(response.body)[0]["city"]).to eq("Austin")
        end
      end
    end
  end
end
