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
end
