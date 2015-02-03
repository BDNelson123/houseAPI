require 'spec_helper'

describe UsersController do
  after(:each) do
    User.destroy_all
  end

  # CREATE action tests
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
end
