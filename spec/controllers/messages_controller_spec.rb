require 'spec_helper'

describe MessagesController do
  before(:each) do
    Message.destroy_all
  end

  # creates the mocked records we need to run our tests
  before(:all) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @home = FactoryGirl.create(:home, user_id: @user1.id)
  end

  # CREATE action tests
  describe "#create" do
    context "authentication" do
      it "should NOT create one record in the database and return a status of 401 as user has to be logged in" do
        post :create, format: :json, :message => { :receiver_id => @user2.id, :home_id => @home.id, :message => "This is a test." }
        expect(response.status).to eq(401)
      end

      it "should create one record in the database and return a status of 201 as user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :receiver_id => @user2.id, :home_id => @home.id, :message => "This is a test." }
        expect(response.status).to eq(201)
      end
    end

    context "strong params" do
      it "should use the logged in user's id for the sender_id, not what is in the param" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :sender_id => 123456789, :receiver_id => @user2.id, :home_id => @home.id, :message => "This is a test." }
        expect(response.status).to eq(201) # making sure param sender_id doesn't FUBAR a successful post

        message = Message.last
        expect(message.sender_id).to_not eq(123456789)
        expect(message.sender_id).to eq(@user1.id)
      end
    end

    context "validations" do
      it "should create one record in the database and return a status of 201 as all validations are met" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :receiver_id => @user2.id, :home_id => @home.id, :message => "This is a test." }
        expect(response.status).to eq(201)
      end

      it "should return a status of # if receiver_id is not present" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :home_id => @home.id, :message => "This is a test." }
        expect(response.status).to eq(422)
      end

      it "should return a status of # if home_id is not present" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :receiver_id => @user2.id, :message => "This is a test." }
        expect(response.status).to eq(422)
      end

      it "should return a status of # if message is not present" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :receiver_id => @user2.id, :home_id => @home.id }
        expect(response.status).to eq(422)
      end
    end

    context "response statements" do
      it "should send back the new message object on a successful post" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :receiver_id => @user2.id, :home_id => @home.id, :message => "This is a test." }
        expect(JSON.parse(response.body)["sender_id"]).to eq(@user1.id)
        expect(JSON.parse(response.body)["receiver_id"]).to eq(@user2.id)
        expect(JSON.parse(response.body)["home_id"]).to eq(@home.id)
        expect(JSON.parse(response.body)["message"]).to eq("This is a test.")
      end

      it "should only send back one record" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        post :create, format: :json, :message => { :receiver_id => @user2.id, :home_id => @home.id, :message => "This is a test." }
        expect(JSON.parse(response.body).length).to eq(6) # 6 fields for one none array
        pp JSON.parse(response.body)
      end
    end

    context "new record in database" do
      it "should create one record in the database" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        expect {post :create, format: :json, :message => { :receiver_id => @user2.id, :home_id => @home.id, :message => "This is a test." }}.to change(Message, :count).by(1)
      end

      it "should not create one record in the database due to validation error" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        expect {post :create, format: :json, :message => { :receiver_id => nil, :home_id => @home.id, :message => "This is a test." }}.to change(Message, :count).by(0)
      end
    end
  end

  # SHOW action tests
  describe "#show" do
    context "authentication" do
      it "should return a status of 401 as user is not logged in" do
        message1 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user2.id, :sender_id => @user1.id )
        message2 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user2.id, :sender_id => @user1.id, :message => "This is not a test.")
        message3 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user3.id, :sender_id => @user1.id, :message => "This is not a test.", :thread_id => 2)

        get :show, { :id => message1.thread_id }
        expect(response.status).to eq(401)
      end

      it "should return a status of 200 as user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        message1 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user2.id, :sender_id => @user1.id )
        message2 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user2.id, :sender_id => @user1.id, :message => "This is not a test.")
        message3 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user3.id, :sender_id => @user1.id, :message => "This is not a test.", :thread_id => 2)

        get :show, { :id => message1.thread_id }
        expect(response.status).to eq(200)
      end
    end

    context "correct records returned" do
      it "should return 2 messages for one thread" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user1.auth_token)
        message1 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user2.id, :sender_id => @user1.id )
        message2 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user2.id, :sender_id => @user1.id, :message => "This is not a test.")
        message3 = FactoryGirl.create(:message, :home_id => @home.id, :receiver_id => @user3.id, :sender_id => @user1.id, :message => "This is not a test.", :thread_id => 2)

        get :show, { :id => message1.thread_id }
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end
  end
end
