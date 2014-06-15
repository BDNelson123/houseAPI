class HomesController < ApplicationController
  respond_to :json

  include ActionController::HttpAuthentication::Token

  before_filter :restrict_access, :only => [:create, :update, :destroy]

  def create
    home = Home.new(home_params)
    home.user_id = User.user_id(token_and_options(request))

    if Zillow.check(home_params) != 0
      render json: { :errors => "This address could not be found in the MLS.  Please make sure you typed it in correctly." }, :status => :unprocessable_entity
    else
      if home.save
        Zillow.createNew(home.user_id, home.id, home_params)
        render json: home, status: :created, id: home.id
      else
        render json: home.errors, status: :unprocessable_entity
      end
    end
  end

  def show
    if params[:image] == 'false'
      home = Home.find(params[:id])
    else
      home = Home.joins("LEFT JOIN images ON images.home_id = homes.id JOIN zillows ON zillows.home_id = homes.id").select('homes.*,zillows.*,array_agg(images.image) AS images').where(:id => params[:id]).group("homes.id, zillows.id")
    end

    if home
      render json: home
    else
      render json: { :errors => "This home was not found." }, :status => :unprocessable_entity
    end
  end

  def update
    home = Home.find_by_id(params[:id])

    if home.update(home_params)
      render json: home, status: :created, id: home.id
    else
      render json: home.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: Home.joins("LEFT JOIN images ON images.home_id = homes.id JOIN zillows ON zillows.home_id = homes.id").select('homes.*,zillows.*,array_agg(images.image) AS images').where(:user_id => User.user_id(token_and_options(request))).group("homes.id, zillows.id")
  end

  def destroy
    home = Home.where(:id => params[:id], :user_id => User.user_id(token_and_options(request))).first

    if home
      render json: home.destroy
    else
      render json: { :errors => "Access Denied." }, :status => :unprocessable_entity
    end
  end

  private

  def home_params
    _params = params.require(:home).permit(
      :id, :address, :address2, :city, :state, :zip
    )
  end
end
