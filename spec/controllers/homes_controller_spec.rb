require 'spec_helper'
include ActionDispatch::TestProcess

describe HomesController, :type => :api do
  # creates the mocked records we need to run our tests
  before(:all) do
    @user = FactoryGirl.create(:user)
    @home = FactoryGirl.create(:home, user_id: @user.id)
    @image = FactoryGirl.create(:image, user_id: @user.id, home_id: @home.id)
    @zillow = FactoryGirl.create(:zillow, user_id: @user.id, home_id: @home.id)
  end

  # INDEX action tests
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

      it "should return an image" do
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

  # SHOW action tests
  describe "#show" do
    context "check validity of user authentication" do
      it "should return a response of 200 if logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'false' }
        expect(response.status).to eq(200)
      end
    end

    context "image param is false" do
      it "should return one home record with 11 attributes no images (no join)" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'false' }
        expect(JSON.parse(response.body).length).to eq(11) # returns 11 fields
      end

      it "should return the correct value for the address attribute" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'false' }
        expect(JSON.parse(response.body)['address']).to eq(@home.address)
      end
    end

    context "image param is true" do
      it "should return a response of 200" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'true' }
        expect(response.status).to eq(200)
      end

      it "should return one home record with images (a join of the images table)" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'true' }
        expect(JSON.parse(response.body).length).to eq(1) # 1 record is returned
      end

      it "should return the correct value for the related_1_zpid attribute" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'true' }
        expect(JSON.parse(response.body)[0]['related_1_address']).to eq(@zillow.related_1_address)
      end

      it "should return the correct value for the related_2_zpid attribute" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'true' }
        expect(JSON.parse(response.body)[0]['related_2_address']).to eq(@zillow.related_2_address)
      end

      it "should return the correct value for the related_1_zpid attribute which is not the same as @zillow.related_2_address" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :show, { 'id' => @home.id, 'user_id' => @user.id, 'image' => 'true' }
        expect(JSON.parse(response.body)[0]['related_1_address']).to_not eq(@zillow.related_2_address)
      end
    end  
  end

  # CREATE action tests
  describe "#create" do
    # I know that this adddress exists because I used to live there
    # therefore I know these tests should return positive results
    it "should create one record in the database for home with a response of 201" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
      post :create, format: :json, :home => {address: "2517 53rd St.", address2: "", city: "Lubbock", state: "TX", zip: 79423, price: 1000}
      expect(response.status).to eq(201)
    end

    it "should NOT create one record in the database for home with a response of 401 due to not being logged in" do
      post :create, format: :json, :home => {address: "2517 53rd St.", address2: "", city: "Lubbock", state: "TX", zip: 79423, price: 1000}
      expect(response.status).to eq(401)
    end

    it "should create one record in the database for home" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
      post :create, format: :json, :home => {address: "2517 53rd St.", address2: "", city: "Lubbock", state: "TX", zip: 79423, price: 1000}
      expect(JSON.parse(response.body).length).to eq(11) # 11 fields are returned for a single record
    end

    it "should create one record in the database for zillow" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
      post :create, format: :json, :home => {address: "2517 53rd St.", address2: "", city: "Lubbock", state: "TX", zip: 79423, price: 1000}

      home = Home.last
      zillow = Zillow.last

      expect(home.id).to eq(zillow.home_id)
    end

    # this works because in the before(:all) we are creating a home record, then creating one here
    # therefore, the first home record should not be in the last zillow record
    it "make sure that home id and zillow home_id are not the same for different records" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
      post :create, format: :json, :home => {address: "2517 53rd St.", address2: "", city: "Lubbock", state: "TX", zip: 79423, price: 1000}

      home = Home.first
      zillow = Zillow.last

      expect(home.id).to_not eq(zillow.home_id)
    end

    # I know that this adddress exists because I used to live there
    # therefore I know these tests should return positive results
    context "positive tests to show a record has been created" do
      it "makes sure only one record for a house is created in the home table" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        expect {post :create, format: :json, :home => {address: "2517 53rd St.", address2: "", city: "Lubbock", state: "TX", zip: 79423, price: 1000}}.to change(Home, :count).by(1)
      end

      it "makes sure only one record for a house is created in the zillow table" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        expect {post :create, format: :json, :home => {address: "2517 53rd St.", address2: "", city: "Lubbock", state: "TX", zip: 79423, price: 1000}}.to change(Zillow, :count).by(1)
      end
    end

    # I know that this adddress DOES NOT exist because I used to live in that neighborhood
    # therefore I know these tests should return negative results
    context "negative tests to show a record has not been created if the house cant be found by zillow" do
      it "makes sure no record for a house is created in the home table" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        expect {post :create, format: :json, :home => {address: "251734 53rd St.", address2: "", city: "tester", state: "TX", zip: 99999, price: 1000}}.to change(Home, :count).by(0)
      end

      it "makes sure no record for a house is created in the zillow table" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        expect {post :create, format: :json, :home => {address: "251734 53rd St.", address2: "", city: "tester", state: "TX", zip: 99999, price: 1000}}.to change(Zillow, :count).by(0)
      end

      it "should return a specific json response if zillow cant find the house the user wants to create" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        post :create, format: :json, :home => {address: "251734 53rd St.", address2: "", city: "tester", state: "TX", zip: 99999, price: 1000}
        response.body.should == "This address could not be found in the MLS.  Please make sure you typed it in correctly."
      end
    end
  end

  # UPDATE action tests
  describe "#update" do
    context "testing authentication - only logged in users can update a record" do
      it "should return a response of 201 if user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        put :update, format: :json, :id => @home.id, :home => {price: 12345}
        expect(response.status).to eq(201)
      end

      it "should return a response of 401 if the user is NOT logged in" do
        put :update, format: :json, :id => @home.id, :home => {price: 12345}
        expect(response.status).to eq(401)
      end
    end

    context "testing if record was updated" do
      it "should not update anything because only the price can be updated" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        before_address = @home.address
        update = put :update, format: :json, :id => @home, :home => {address: "7615 Navarro Pl.", address2: "", city: "Austin", state: "TX", zip: 78749}
        @home.reload
        expect(@home.address).to eq(before_address)
      end

      it "should not add a new record since the record is being updated - and its updating attributes which can't be updated" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        update = put :update, format: :json, :id => @home, :home => {address: "7615 Navarro Pl.", address2: "", city: "Austin", state: "TX", zip: 78749}
        @home.reload
        expect {update}.to change(Home, :count).by(0)
        expect {update}.to change(Zillow, :count).by(0)
      end

      it "should not add a new record since the record is being updated" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        update = put :update, format: :json, :id => @home, :home => {price: 12345}
        @home.reload
        expect {update}.to change(Home, :count).by(0)
        expect {update}.to change(Zillow, :count).by(0)
      end

      it "should update the record with the correct new information" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        put :update, format: :json, :id => @home, :home => {price: 12345}
        @home.reload
        expect(@home.price.to_i).to eq(12345)
      end
    end
  end
end
