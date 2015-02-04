require 'spec_helper'

describe UsersController do
  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
  end

  after(:each) do
    User.destroy_all
  end

  # CREATE action tests
  # NOTE: user does not need to be signed in to create a user...for obvious reasons
  describe "#create" do
    context "successful create" do
      it "should return a http status of 201" do
        post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "testing123" }
        expect(response.status).to eq(201)
      end

      it "should add one record to the user table" do
        expect{post :create, format: :json, :user => { :firstname => "Brian", :lastname => "Wilson", :email => "brian@wilson.com", :password => "testing123", :password_confirmation => "testing123" }}.to change(User, :count).by(1)
      end

      it "should return the user information after the create" do
        post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "testing123" }
        user = User.last
        expect(JSON.parse(response.body)["id"]).to eq(user.id)
        expect(JSON.parse(response.body)["auth_token"]).to eq(user.auth_token)
        expect(JSON.parse(response.body)["active"]).to eq(true)
      end

      it "should return only one user's information" do
        post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "testing123" }
        expect(JSON.parse(response.body).length).to eq(9) # id, email, password_digest, created_at, updated_at, auth_token, firstname, lastname, active
      end
    end

    context "unsuccessful create" do
      it "should return a http status of 422 if email has been taken" do
        user = FactoryGirl.create(:user, :email => "tester@tester.com")
        post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => "tester@tester.com", :password => "testing123", :password_confirmation => "testing123" }
        expect(response.status).to eq(422)
        expect{post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => "tester@tester.com", :password => "testing123", :password_confirmation => "testing123" }}.to change(User, :count).by(0)
        expect(response.body).to eq("Email has already been taken")
      end

      it "should return a http status of 422 if passwords dont' match" do
        post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "wrongPassword123" }
        expect(response.status).to eq(422)
        expect{post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => "tester@tester.com", :password => "testing123", :password_confirmation => "wrongPassword123" }}.to change(User, :count).by(0)
        expect(response.body).to eq("Password confirmation doesn't match Password")
      end

      it "should return a http status of 422 if firstname is nil" do
        post :create, format: :json, :user => { :firstname => nil, :lastname => "Nelson", :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "testing123" }
        expect(response.status).to eq(422)
        expect{post :create, format: :json, :user => { :firstname => nil, :lastname => "Nelson", :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "testing123" }}.to change(User, :count).by(0)
        expect(response.body).to eq("Firstname can't be blank")
      end

      it "should return a http status of 422 if lastname is nil" do
        post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => nil, :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "testing123" }
        expect(response.status).to eq(422)
        expect{post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => nil, :email => "benjamin@nelson.com", :password => "testing123", :password_confirmation => "testing123" }}.to change(User, :count).by(0)
        expect(response.body).to eq("Lastname can't be blank")
      end

      it "should return a http status of 422 if email is nil" do
        post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => nil, :password => "testing123", :password_confirmation => "testing123" }
        expect(response.status).to eq(422)
        expect{post :create, format: :json, :user => { :firstname => "Benjamin", :lastname => "Nelson", :email => nil, :password => "testing123", :password_confirmation => "testing123" }}.to change(User, :count).by(0)
        expect(response.body).to eq("Email can't be blank and Email does not appear to be valid")
      end
    end
  end

  # SHOW action tests
  describe "#show" do
    context "authentication" do
      it "should allow you to view a person's profile if you are logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        get :show, { 'id' => @user2.id }
        expect(response.status).to eq(200)
      end

      it "should not allow you to view a person's profile unless you are logged in" do
        get :show, { 'id' => @user2.id }
        expect(response.status).to eq(401)
      end
    end

    context "user exists" do
      it "should return the user information if the user exists" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        get :show, { 'id' => @user2.id }
        expect(JSON.parse(response.body).length).to eq(9)
      end

      it "should return an error message if the user does not exist" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        get :show, { 'id' => 123123123123123 }
        expect(response.body).to eq("This user was not found.")
        expect(response.status).to eq(422)
      end
    end

    context "returns correct values" do
      it "should return the correct values for @user2" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        get :show, { 'id' => @user2.id }
        expect(JSON.parse(response.body)["id"]).to eq(@user2.id)
        expect(JSON.parse(response.body)["email"]).to eq(@user2.email)
        expect(JSON.parse(response.body)["password_digest"]).to eq(@user2.password_digest)
        expect(JSON.parse(response.body)["auth_token"]).to eq(@user2.auth_token)
        expect(JSON.parse(response.body)["firstname"]).to eq(@user2.firstname)
        expect(JSON.parse(response.body)["lastname"]).to eq(@user2.lastname)
        expect(JSON.parse(response.body)["active"]).to eq(@user2.active)
      end
    end
  end
end
