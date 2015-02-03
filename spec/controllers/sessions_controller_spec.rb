require 'spec_helper'

describe SessionsController do
  before(:all) do
    @user = FactoryGirl.create(:user, :password => "testing123", :password_confirmation => "testing123")
  end

  after(:all) do
    User.destroy_all
  end

  # SHOW action tests
  describe "#show" do
    context "correct login credentials" do
      it "should return the users information on a correct user login" do
        get :show, { :id => "show", :email => @user.email, :password => "testing123" }
        expect(response.status).to eq(200)
      end

      it "should return one user record" do
        get :show, { :id => "show", :email => @user.email, :password => "testing123" }
        expect(JSON.parse(response.body).length).to eq(9) # 9 fields
      end

      it "should return one user record" do
        get :show, { :id => "show", :email => @user.email, :password => "testing123" }
        expect(JSON.parse(response.body)["id"]).to eq(@user.id)
        expect(JSON.parse(response.body)["auth_token"]).to eq(@user.auth_token)
        expect(JSON.parse(response.body)["email"]).to eq(@user.email)
        expect(JSON.parse(response.body)["firstname"]).to eq(@user.firstname)
        expect(JSON.parse(response.body)["lastname"]).to eq(@user.lastname)
      end
    end

    context "incorrect login credentials" do
      it "should return Your credentials were not found.  Please try again if the password is wrong" do
        get :show, { :id => "show", :email => @user.email, :password => "wrongPassword123" }
        expect(response.body).to eq("Your credentials were not found.  Please try again")
      end

      it "should return Your credentials were not found.  Please try again if the email is wrong" do
        get :show, { :id => "show", :email => "wrong@email.com", :password => "testing123" }
        expect(response.body).to eq("Your credentials were not found.  Please try again")
      end
    end
  end
end
