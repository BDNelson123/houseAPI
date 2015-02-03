require 'spec_helper'
include ActionDispatch::TestProcess

describe SearchesController do
  # have to create the factories we need, have to create a zillow and image record for
  # each home factory due to joins on the query
  before(:all) do
    @user = FactoryGirl.create(:user)

    @home1 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home1", :user_id => @user.id )
    @zillow1 = FactoryGirl.create(:zillow, :home_id => @home1.id, :user_id => @user.id )
    @image1 = FactoryGirl.create(:image, :home_id => @home1.id, :user_id => @user.id )

    @home2 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home2", :user_id => @user.id )
    @zillow2 = FactoryGirl.create(:zillow, :home_id => @home2.id, :user_id => @user.id )
    @image2 = FactoryGirl.create(:image, :home_id => @home2.id, :user_id => @user.id )

    @home3 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home3", :user_id => @user.id )
    @zillow3 = FactoryGirl.create(:zillow, :home_id => @home3.id, :user_id => @user.id )
    @image3 = FactoryGirl.create(:image, :home_id => @home3.id, :user_id => @user.id )

    @home4 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home4", :user_id => @user.id )
    @zillow4 = FactoryGirl.create(:zillow, :home_id => @home4.id, :user_id => @user.id )
    @image4 = FactoryGirl.create(:image, :home_id => @home4.id, :user_id => @user.id )

    @home5 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home5", :user_id => @user.id )
    @zillow5 = FactoryGirl.create(:zillow, :home_id => @home5.id, :user_id => @user.id )
    @image5 = FactoryGirl.create(:image, :home_id => @home5.id, :user_id => @user.id )

    @home6 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home6", :user_id => @user.id )
    @zillow6 = FactoryGirl.create(:zillow, :home_id => @home6.id, :user_id => @user.id )
    @image6 = FactoryGirl.create(:image, :home_id => @home6.id, :user_id => @user.id )

    @home7 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home7", :user_id => @user.id )
    @zillow7 = FactoryGirl.create(:zillow, :home_id => @home7.id, :user_id => @user.id )
    @image7 = FactoryGirl.create(:image, :home_id => @home7.id, :user_id => @user.id )

    @home8 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home8", :user_id => @user.id )
    @zillow8 = FactoryGirl.create(:zillow, :home_id => @home8.id, :user_id => @user.id )
    @image8 = FactoryGirl.create(:image, :home_id => @home8.id, :user_id => @user.id )

    @home9 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home9", :user_id => @user.id )
    @zillow9 = FactoryGirl.create(:zillow, :home_id => @home9.id, :user_id => @user.id )
    @image9 = FactoryGirl.create(:image, :home_id => @home9.id, :user_id => @user.id )

    @home10 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home10", :user_id => @user.id )
    @zillow10 = FactoryGirl.create(:zillow, :home_id => @home10.id, :user_id => @user.id )
    @image10 = FactoryGirl.create(:image, :home_id => @home10.id, :user_id => @user.id )

    @home11 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home11", :user_id => @user.id )
    @zillow11 = FactoryGirl.create(:zillow, :home_id => @home11.id, :user_id => @user.id )
    @image11 = FactoryGirl.create(:image, :home_id => @home11.id, :user_id => @user.id )

    @home12 = FactoryGirl.create(:home, :address => "2517 53rd St.", :address2 => "home12", :user_id => @user.id )
    @zillow12 = FactoryGirl.create(:zillow, :home_id => @home12.id, :user_id => @user.id )
    @image12 = FactoryGirl.create(:image, :home_id => @home12.id, :user_id => @user.id )
  end

  after(:all) do
    Home.destroy_all
  end

  # INDEX action tests
  describe "#index" do
    context "authentication" do
      it "should return a status of 200 as user is not logged in" do
        get :index, { :query => "2517", :page => 1, :count => "false" }
        expect(response.status).to eq(200)
      end

      it "should return a status of 200 as user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        get :index, { :query => "2517", :page => 1, :count => "false" }
        expect(response.status).to eq(200)
      end
    end

    context "params count = true" do
      it "should return a status of 200" do
        get :index, { :query => "2517", :page => 1, :count => "true" }
        expect(response.status).to eq(200)
      end

      it "should return all homes that match the search" do
        get :index, { "query" => "2517", :page => "1", :count => "true" }
        response.body.should include([[12]].to_s)
      end

      it "should return not return 5 results, it should return 12 results" do
        get :index, { "query" => "2517", :page => "1", :count => "true" }
        response.body.should_not include([[5]].to_s)
      end
    end

    context "params count = false" do
      it "should return a status of 200" do
        get :index, { :query => "2517", :page => 1, :count => "false" }
        expect(response.status).to eq(200)
      end

      it "should return 10 records for page 1" do
        get :index, { "query" => "2517", :page => "1", :count => "false" }
        expect(JSON.parse(response.body).length).to eq(10)
      end

      it "should return 2 records for page 2" do
        get :index, { "query" => "2517", :page => "2", :count => "false" }
        expect(JSON.parse(response.body).length).to eq(2)
      end

      # NOTE: made sure to change the address2 attribute for all factories so we can test against that
      it "should return the correct values for address2 for each record ordered by updated_at on page 1" do
        get :index, { "query" => "2517", :page => "1", :count => "false" }
        expect(JSON.parse(response.body)[0]["address2"]).to eq("home12")
        expect(JSON.parse(response.body)[1]["address2"]).to eq("home11")
        expect(JSON.parse(response.body)[2]["address2"]).to eq("home10")
        expect(JSON.parse(response.body)[3]["address2"]).to eq("home9")
        expect(JSON.parse(response.body)[4]["address2"]).to eq("home8")
        expect(JSON.parse(response.body)[5]["address2"]).to eq("home7")
        expect(JSON.parse(response.body)[6]["address2"]).to eq("home6")
        expect(JSON.parse(response.body)[7]["address2"]).to eq("home5")
        expect(JSON.parse(response.body)[8]["address2"]).to eq("home4")
        expect(JSON.parse(response.body)[9]["address2"]).to eq("home3")
      end

      # NOTE: made sure to change the address2 attribute for all factories so we can test against that
      it "should return the correct values for address2 for each record ordered by updated_at on page 2" do
        get :index, { "query" => "2517", :page => "2", :count => "false" }
        expect(JSON.parse(response.body)[0]["address2"]).to eq("home2")
        expect(JSON.parse(response.body)[1]["address2"]).to eq("home1")
      end
    end    
  end
end
