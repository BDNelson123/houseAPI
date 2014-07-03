class ImagesController < ApplicationController
  respond_to :json

  include ActionController::HttpAuthentication::Token

  before_filter :restrict_access, :only => [:create, :delete, :update]

  def create
    image = Image.new(:image => params[:file], :user_id => User.user_id(token_and_options(request)), :home_id => params[:home_id], :klass => params[:klass])

    if image.save
      render json: image, status: :created, image: image.image
    else
      render json: image.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: Image.query(params)
  end

  def update
    if Image.where(:klass => params[:klass], Common.klass(params[:klass]) => params[:id], :primary => true).first
      old_primary = Image.where(:klass => params[:klass], Common.klass(params[:klass]) => Common.klass_id(params,User.user_id(token_and_options(request))), :primary => true).first.update(:primary => false)
    end
    new_primary = Image.where(:klass => params[:klass], Common.klass(params[:klass]) => Common.klass_id(params,User.user_id(token_and_options(request))), :id => params[:id]).first.update(:primary => true)

    if new_primary
      render json: new_primary, status: :created
    else
      render json: new_primary.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: Image.where(:user_id => params[:id])
  end

  def destroy
    image = Image.find_by_id(params[:id])
    image.destroy
  end
end
