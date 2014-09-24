require 'spec_helper'
include ActionDispatch::TestProcess

describe HomesController, :type => :api do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @home = FactoryGirl.create(:home, user_id: @user.id)
    @image = FactoryGirl.create(:image, user_id: @user.id, home_id: @home.id)
    @zillow = FactoryGirl.create(:zillow, user_id: @user.id, home_id: @home.id)
  end

  describe "#index" do
    context "basic param is false" do
      it "should return 1 total row" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'false' }
        expect(JSON.parse(response.body).length).to eq(1)
      end

      it "should return all zillow attributes such as yearBuilt" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'false' }
        JSON.parse(response.body)[0].should include('yearBuilt')
      end

      it "should return images attribute" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'false' }
        JSON.parse(response.body)[0].should include('images')
      end

      it "should return the correct value for yearBuilt" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'false' }
        expect(JSON.parse(response.body)[0]['yearBuilt'].to_i).to eq(@zillow.yearBuilt.to_i)
      end

      it "should return a response of 200" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'false' }
        expect(response.status).to eq(200)
      end
    end

    context "basic param is true" do
      it "should return 1 total row" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'true' }
        expect(JSON.parse(response.body).length).to eq(1)
      end

      it "should return images attribute" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'true' }
        JSON.parse(response.body)[0].should include('images')
      end

      it "should return an images " do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'true' }
        expect(response.status).to eq(200)
      end

      it "should return a response of 200" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { 'user_id' => @user.id, 'basic' => 'true' }
        expect(response.status).to eq(200)
      end
    end
  end
end
