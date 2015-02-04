require 'spec_helper'

describe UsersController do
  before(:each) do
    @firstname1 = "Eric"
    @lastname1 = "Draven"
    @email1 = "eric@draven.com"
    @password1 = "testing123"

    @firstname2 = "Shelly"
    @lastname2 = "Webster"
    @email2 = "shelly@webster.com"
    @password2 = "testing12345"

    @user1 = FactoryGirl.create(:user, :firstname => @firstname1, :lastname => @lastname1, :email => @email1, :password => @password1, :password_confirmation => @password1, :auth_token => User.auth_token)
    @user2 = FactoryGirl.create(:user, :firstname => @firstname2, :lastname => @lastname2, :email => @email2, :password => @password2, :password_confirmation => @password2, :auth_token => User.auth_token)
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
      it "should allow you to view a person's profile if you are logged in - should return status of 200" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        get :show, { 'id' => @user2.id }
        expect(response.status).to eq(200)
      end

      it "should not allow you to view a person's profile unless you are logged in - should return status of 401" do
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

  # UPDATE action tests
  describe "#update" do
    context "authentication" do
      it "should return a response of 201 if user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => "Test", :password => @password1, :password_confirmation => @password1 }
        expect(response.status).to eq(201)
      end

      it "should return a response of 401 if the user is NOT logged in" do
        put :update, format: :json, :id => @user1.id, :user => { :firstname => "Test", :password => @password1, :password_confirmation => @password1 }
        expect(response.status).to eq(401)
      end
    end

    context "record number" do
      it "should not add or delete a record from the database - just update one" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        expect{put :update, format: :json, :id => @user1.id, :user => { :firstname => "Test", :password => @password1, :password_confirmation => @password1 }}.to change(User, :count).by(0)
      end
    end

    context "record updated" do
      it "should update the user's firstname only" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => "Test", :password => @password1, :password_confirmation => @password1 }
        @user1.reload
        expect(@user1.firstname).to eq("Test")
        expect(@user1.lastname).to eq(@lastname1)
        expect(@user1.email).to eq(@email1)
      end

      it "should update the user's lastname only" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :lastname => "Test", :password => @password1, :password_confirmation => @password1 }
        @user1.reload
        expect(@user1.firstname).to eq(@firstname1)
        expect(@user1.lastname).to eq("Test")
        expect(@user1.email).to eq(@email1)
      end

      it "should update the user's email only" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :lastname => "Test", :password => @password1, :password_confirmation => @password1 }
        @user1.reload
        expect(@user1.firstname).to eq(@firstname1)
        expect(@user1.lastname).to eq("Test")
        expect(@user1.email).to eq(@email1)
      end
    end

    context "user not found" do
      it "should return 'Permission Denied' if user is trying to edit someone else's profile" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user2.id, :user => { :firstname => "Test", :password => @password2, :password_confirmation => @password2 }
        expect(response.body).to eq("Permission Denied")
      end

      it "should return 'Permission Denied' if user isnt found" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => 123123123123123123, :user => { :firstname => "Test", :password => @password1, :password_confirmation => @passwor1 }
        expect(response.body).to eq("Permission Denied")
      end
    end

    context "validations" do
      it "should return an error if firstname is nil" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => nil, :password => @password1, :password_confirmation => @password1 }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Firstname can't be blank")
      end

      it "should return an error if lastname is nil" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => "Test", :password => nil, :password_confirmation => @password1 }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Password can't be blank")
      end

      it "should return an error if email is nil" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => "Test", :email => nil, :password => @password1, :password_confirmation => @password1 }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Email can't be blank and Email does not appear to be valid")
      end

      it "should return an error if password does not match password_confirmation" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => @firstname1, :lastname => @lastname1, :email => @email1, :password => @password1, :password_confirmation => "Tester12345" }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Password confirmation doesn't match Password")
      end

      it "should return two errors if firstname and lastname are nil" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => nil, :lastname => nil, :email => @email1, :password => @password1, :password_confirmation => @password1 }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Firstname can't be blank and Lastname can't be blank")
      end

      it "should return three errors if firstname, lastname, and email are nil" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => nil, :lastname => nil, :email => nil, :password => @password1, :password_confirmation => @password1 }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Firstname can't be blank, Lastname can't be blank, Email can't be blank, and Email does not appear to be valid")
      end

      it "should return five errors if firstname, lastname, email, and password are nil" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => nil, :lastname => nil, :email => nil, :password => nil, :password_confirmation => @password1 }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Firstname can't be blank, Lastname can't be blank, Email can't be blank, Email does not appear to be valid, and Password can't be blank")
      end

      it "should return six errors if firstname, lastname, email, password, and password_confirmation are nil" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        put :update, format: :json, :id => @user1.id, :user => { :firstname => nil, :lastname => nil, :email => nil, :password => nil, :password_confirmation => nil }
        expect(response.status).to eq(422)
        expect(response.body).to eq("Firstname can't be blank, Lastname can't be blank, Email can't be blank, Email does not appear to be valid, Password can't be blank, and Password confirmation can't be blank")
      end
    end
  end
end
