require 'spec_helper'
include ActionDispatch::TestProcess

describe Image do
  context "validations" do
    context "presence = true" do
      it "should return one validation error for user_id" do
        image = Image.new(:image => fixture_file_upload('photos/test.jpg', 'image/jpg'), :user_id => nil, :home_id => 1, :klass => "home")
        image.should have(1).error_on(:user_id)
        image.should have(0).error_on(:image)
        image.should have(0).error_on(:klass)
      end

      it "should return one validation error for image" do
        image = Image.new(:image => nil, :user_id => 1, :home_id => 1, :klass => "home")
        image.should have(0).error_on(:user_id)
        image.should have(1).error_on(:image)
        image.should have(0).error_on(:klass)
      end

      it "should return one validation error for klass" do
        image = Image.new(:image => fixture_file_upload('photos/test.jpg', 'image/jpg'), :user_id => 1, :home_id => 1, :klass => nil)
        image.should have(0).error_on(:user_id)
        image.should have(0).error_on(:image)
        image.should have(1).error_on(:klass)
      end
    end
  end

  context "query" do
    context "primary = true" do
      context "klass = home" do
        it "should return the correct query" do
          image = Image.new(:image => fixture_file_upload('photos/test.jpg', 'image/jpg'), :user_id => 1, :home_id => 1, :klass => "home")
          params = {:primary => "true", :klass => "home", :id => "1"}
          expect(Image.query(params)).to eq(Image.where(:klass => params[:klass], Common.klass(params[:klass]) => params[:id], :primary => true).first)
        end
      end

      context "klass = user" do
        it "should return the correct query" do
          image = Image.new(:image => fixture_file_upload('photos/test.jpg', 'image/jpg'), :user_id => 1, :klass => "user")
          params = {:primary => "true", :klass => "user", :id => "1"}
          expect(Image.query(params)).to eq(Image.where(:klass => params[:klass], Common.klass(params[:klass]) => params[:id], :primary => true).first)
        end
      end
    end

    context "primary = false" do
      context "klass = home" do
        it "should return the correct query" do
          image = Image.new(:image => fixture_file_upload('photos/test.jpg', 'image/jpg'), :user_id => 1, :home_id => 1, :klass => "home")
          params = {:primary => "false", :klass => "home", :id => "1"}
          expect(Image.query(params)).to eq(Image.where(:klass => params[:klass], Common.klass(params[:klass]) => params[:id]))
        end
      end

      context "klass = user" do
        it "should return the correct query" do
          image = Image.new(:image => fixture_file_upload('photos/test.jpg', 'image/jpg'), :user_id => 1, :klass => "user")
          params = {:primary => "false", :klass => "user", :id => "1"}
          expect(Image.query(params)).to eq(Image.where(:klass => params[:klass], Common.klass(params[:klass]) => params[:id]))
        end
      end
    end
  end
end
