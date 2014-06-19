class ImagesController < ApplicationController
  respond_to :json

  include ActionController::HttpAuthentication::Token

  before_filter :restrict_access, :only => [:create, :delete]

  def create
    image = Image.new(:image => params[:file], :user_id => User.user_id(token_and_options(request)), :home_id => params[:home_id], :klass => params[:klass])

    if image.save
      render json: image, status: :created, image: image.image
    else
      render json: image.errors, status: :unprocessable_entity
    end
  end

  def show
    if params[:klass] == 'home'
      render json: Image.where(:klass => 'home', :home_id => params[:id])
    else
      render json: Image.where(:klass => 'user', :user_id => User.user_id(params[:id]))
    end
  end

  def index
    render json: Image.where(:user_id => User.user_id(params[:token]))
  end

  def destroy
    image = Image.find_by_id(params[:id])
    image.destroy
  end
end
