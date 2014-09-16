class ImagesController < ApplicationController
  respond_to :json
  include ActionController::HttpAuthentication::Token
  before_filter :restrict_access, :only => [:create, :delete, :update]

  def create
    image = Image.new(:image => params[:file], :user_id => User.user_id(token_and_options(request)), :home_id => params[:home_id], :klass => params[:klass])

    if image.save
      render json: image, status: :created, image: image.image
    else
      render json: image.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def show
    render json: Image.query(params)
  end

  def update
    old_primary = Image.where(:klass => params[:klass], Common.klass(params[:klass]) => Common.klass_id(params,User.user_id(token_and_options(request))), :primary => true).update_all(:primary => false)
    new_primary = Image.where(:klass => params[:klass], Common.klass(params[:klass]) => Common.klass_id(params,User.user_id(token_and_options(request))), :id => params[:id]).first.update(:primary => true)

    if new_primary
      render json: new_primary, status: :created
    else
      render json: new_primary.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def index
    if params[:type] == 'message'
      #render json: Image.joins(:user).select("images.*,users.firstname,users.lastname").where(:primary => true).where("user_id IN (?)", eval(params['id']))
      render json: Image.where(:primary => true).where("user_id IN (?)", eval(params['id']))
    else
      render json: Image.where(:user_id => params[:id])
    end
  end

  def destroy
    image = Image.find_by_id(params[:id])
    image.destroy
  end
end
