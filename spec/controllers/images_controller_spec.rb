require 'spec_helper'
include ActionDispatch::TestProcess

describe ImagesController do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @home = FactoryGirl.create(:home, user_id: @user.id)
  end

  # CREATE action tests
  describe "#create" do
    context "successful create" do
      it "should create one record in the database for image with a response of 201" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        post :create, format: :json, :file => fixture_file_upload('photos/test.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"
        expect(response.status).to eq(201)
      end
    end

    context "validations" do
      it "should create zero records in the database for image with a response of 422 - validation: no file" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        post :create, format: :json, :file => nil, :home_id => @home.id, :klass => "home"
        expect(response.status).to eq(422)
      end

      it "should create zero records in the database for image with a response of 422 - validation: no klass" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        post :create, format: :json, :file => fixture_file_upload('photos/test.jpg', 'image/jpg'), :home_id => @home.id, :klass => nil
        expect(response.status).to eq(422)
      end
    end

    context "user authentication" do
      it "should create zero records in the database for image with a response of 201 - not authorized - have to be logged in to create record" do
        post :create, format: :json, :file => fixture_file_upload('photos/test.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"
        expect(response.status).to eq(401)
      end

      it "should change the number of records in the image model by 0 since not logged in" do
        expect{ post :create, format: :json, :file => fixture_file_upload('photos/test.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"}.to change(Image, :count).by(0)
      end
    end

    context "created / deleted count" do
      it "should change the number of records in the image model by 1" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        expect{ post :create, format: :json, :file => fixture_file_upload('photos/test.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"}.to change(Image, :count).by(1)
      end
    end
  end

  # SHOW action tests
  describe "#show" do
    context "primary = true" do
      context "successful show" do
        it "should return a status of 200 when user is logged in" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
          image = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
          get :show, { :klass => "home", :id => @home.id, :primary => true }
          expect(response.status).to eq(200)
        end

        it "should return a status of 200 when user is NOT logged in" do
          image = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
          get :show, { :klass => "home", :id => @home.id, :primary => true }
          expect(response.status).to eq(200)
        end
      end

      context "correct information" do
        it "should contain a user_id attribute with the correct value" do
          image = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
          get :show, { :klass => "home", :id => @home.id, :primary => true }
          expect(JSON.parse(response.body)[0]["user_id"].to_i).to eq(@user.id.to_i)
        end

        it "should contain a home_id attribute with the correct value" do
          image = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
          get :show, { :klass => "home", :id => @home.id, :primary => true }
          expect(JSON.parse(response.body)[0]["home_id"].to_i).to eq(@home.id.to_i)
        end
      end

      context "records returned" do
        it "should return one record" do
          image = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
          get :show, { :klass => "home", :id => @home.id, :primary => true }
          expect(JSON.parse(response.body).length).to eq(1)
        end
      end
    end

    context "primary = false" do
      context "successful show" do
        it "should return a status of 200 when user is logged in" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
          image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
          image2 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
          get :show, { :klass => "home", :id => @home.id, :primary => false }
          expect(response.status).to eq(200)
        end

        it "should return a status of 200 when user is NOT logged in" do
          image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
          image2 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
          get :show, { :klass => "home", :id => @home.id, :primary => false }
          expect(response.status).to eq(200)
        end
      end

      context "records returned" do
        it "should return one record" do
          image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
          image2 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
          get :show, { :klass => "home", :id => @home.id, :primary => false }
          expect(JSON.parse(response.body).length).to eq(2)
        end
      end
    end   
  end

  # UPDATE action tests
  describe "#update" do
    context "authentication" do
      it "should return a response of 201 if user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        put :update, format: :json, :id => image2.id, :file => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"
        expect(response.status).to eq(201)
      end

      it "should return a response of 401 if the user is NOT logged in" do
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        put :update, format: :json, :id => image2.id, :file => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"
        expect(response.status).to eq(401)
      end
    end

    context "created / deleted count" do
      it "should not change the number of records in the image model" do
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        expect{put :update, format: :json, :id => image2.id, :file => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"}.to change(Image, :count).by(0)
      end
    end

    context "successful update" do
      it "should return the new primary image record - only one record" do
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        put :update, format: :json, :id => image2.id, :file => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :home_id => @home.id, :klass => "home"
        expect(JSON.parse(response.body).length).to eq(1)
      end

      it "should return the new primary image record with the correct home id" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        put :update, format: :json, :id => image2.id, :home_id => @home.id, :klass => "home"
        expect(JSON.parse(response.body)[0]["home_id"].to_i).to eq(@home.id.to_i)
      end

      it "should return the new primary image record with the correct home id - make sure its the correct home id" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        put :update, format: :json, :id => image2.id, :home_id => @home.id, :klass => "home"
        expect(JSON.parse(response.body)[0]["home_id"].to_i).to_not eq(123456789)
      end

      it "should return the new primary image record with the correct image" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        put :update, format: :json, :id => image2.id, :home_id => @home.id, :klass => "home"
        expect(JSON.parse(response.body)[0]["image"]["url"]).to eq("/uploads/image/image/#{image2.id}/test2.jpg")
      end

      it "should return the new primary image record with the correct primary attribute" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :home_id => @home.id, :klass => "home", :primary => false)
        put :update, format: :json, :id => image2.id, :home_id => @home.id, :klass => "home"
        expect(JSON.parse(response.body)[0]["primary"]).to eq(true)
      end
    end
  end

  # INDEX action tests
  describe "#index" do
    context "authentication" do
      it "should return a response of 200 if user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
        get :index, { :id => @user.id }
        expect(response.status).to eq(200)
      end

      it "should return a response of 200 if user is NOT logged in" do
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
        get :index, { :id => @user.id }
        expect(response.status).to eq(200)
      end
    end
      
    context "type != message" do
      it "should return 2 images for the user" do
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
        get :index, { :id => @user.id }
        expect(JSON.parse(response.body).length).to eq(2)
      end

      it "should return the correct 2 images" do
        image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
        get :index, { :id => @user.id }
        expect(JSON.parse(response.body)[0]["image"]["url"]).to eq("/uploads/image/image/#{image1.id}/test.jpg")
        expect(JSON.parse(response.body)[1]["image"]["url"]).to eq("/uploads/image/image/#{image2.id}/test2.jpg")
      end
    end

    context "type = message" do
      context "returned records" do
        it "should return one image - the primary ones for the first user in a conversation" do
          user1_image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
          user1_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
          user2 = FactoryGirl.create(:user)
          user2_image1 = FactoryGirl.create(:image, :user_id => user2.id, :klass => "user", :primary => true)
          user2_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => user2.id, :klass => "user", :primary => false)

          get :index, { :id => @user.id, :type => "message" }
          expect(JSON.parse(response.body).length).to eq(1)
        end

        it "should return 2 images - the primary ones for each user in a conversation" do
          user1_image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
          user1_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
          user2 = FactoryGirl.create(:user)
          user2_image1 = FactoryGirl.create(:image, :user_id => user2.id, :klass => "user", :primary => true)
          user2_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => user2.id, :klass => "user", :primary => false)

          get :index, { :id => "[#{@user.id},#{user2.id}]", :type => "message" }
          expect(JSON.parse(response.body).length).to eq(2)
        end

        it "should return 1 image since one of the users does not have a primary image" do
          user1_image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => false)
          user1_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
          user2 = FactoryGirl.create(:user)
          user2_image1 = FactoryGirl.create(:image, :user_id => user2.id, :klass => "user", :primary => true)
          user2_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => user2.id, :klass => "user", :primary => false)

          get :index, { :id => "[#{@user.id},#{user2.id}]", :type => "message" }
          expect(JSON.parse(response.body).length).to eq(1)
        end

        it "should return 0 images since both of the users does not have a primary image" do
          user1_image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => false)
          user1_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
          user2 = FactoryGirl.create(:user)
          user2_image1 = FactoryGirl.create(:image, :user_id => user2.id, :klass => "user", :primary => false)
          user2_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => user2.id, :klass => "user", :primary => false)

          get :index, { :id => "[#{@user.id},#{user2.id}]", :type => "message" }
          expect(JSON.parse(response.body).length).to eq(0)
        end
      end

      context "correct records returned" do
        it "should return the correct primary images for both users in the message" do
          user1_image1 = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
          user1_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => @user.id, :klass => "user", :primary => false)
          user2 = FactoryGirl.create(:user)
          user2_image1 = FactoryGirl.create(:image, :user_id => user2.id, :klass => "user", :primary => true)
          user2_image2 = FactoryGirl.create(:image, :image => fixture_file_upload('photos/test2.jpg', 'image/jpg'), :user_id => user2.id, :klass => "user", :primary => false)

          get :index, { :id => "[#{@user.id},#{user2.id}]", :type => "message" }

          expect(JSON.parse(response.body)[0]["image"]["url"]).to eq("/uploads/image/image/#{user1_image1.id}/test.jpg")
          expect(JSON.parse(response.body)[1]["image"]["url"]).to eq("/uploads/image/image/#{user2_image1.id}/test.jpg")
          expect(JSON.parse(response.body)[0]["image"]["url"]).to_not eq("/uploads/image/image/#{user1_image2.id}/test2.jpg")
          expect(JSON.parse(response.body)[1]["image"]["url"]).to_not eq("/uploads/image/image/#{user2_image2.id}/test2.jpg")
        end
      end
    end
  end

  # DELETE action tests
  describe "#destroy" do
    context "created / deleted count" do
      it "should change the number of records in the image model by 0 since not logged in" do
        image = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        expect{delete :destroy, format: :json, :id => image}.to change(Image, :count).by(0)
      end

      it "should change the number of records in the image model by 1 since is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        expect{delete :destroy, format: :json, :id => image}.to change(Image, :count).by(-1)
      end
    end

    context "response codes" do
      it "should return a reponse status of 401 as user is not logged in" do
        image = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        delete :destroy, format: :json, :id => image
        expect(response.status).to eq(401)
      end

      it "should return a reponse status of 202 as user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        delete :destroy, { :id => image }
        expect(response.status).to eq(202)
      end

      it "should return a reponse status of 202 as user is logged in" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.auth_token)
        image = FactoryGirl.create(:image, :user_id => @user.id, :klass => "user", :primary => true)
        delete :destroy, { :id => 123456789 }
        expect(response.status).to eq(422)
      end
    end
  end
end
