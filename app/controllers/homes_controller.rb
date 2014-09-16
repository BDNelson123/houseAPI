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
        Log.home_create(home.user_id,home.id,home_params)
        Zillow.createNew(home.user_id, home.id, home_params)
        render json: home, status: :created, id: home.id
      else
        render json: home.errors.full_messages.to_sentence, status: :unprocessable_entity
      end
    end
  end

  def show
    if params[:image] == 'false'
      home = Home.where(:id => params[:id], :active => true, :user_id => User.user_id(token_and_options(request))).first
    else
      home = Home.home_joins.home_attributes.where(:id => params[:id], :active => true).group("homes.id, zillows.id")
    end

    if home.blank?
      render json: { :errors => "Permission Denied" }, :status => :unprocessable_entity
    else
      render json: home
    end
  end

  def update
    home = Home.where(:id => params[:id], :user_id => User.user_id(token_and_options(request))).first

    if home.blank?
      render json: { :errors => "Permission Denied" }, :status => :unprocessable_entity
    elsif home.update(home_params_update)
      Log.home_update(User.user_id(token_and_options(request)),home)
      render json: home, status: :created, id: home.id
    else
      render json: home.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def index
    if params[:basic] == 'true'
      render json: Home.home_joins_basic.select("homes.*,array_agg(images.image) AS images").where(:user_id => Common.home_user(params[:user_id], User.user_id(token_and_options(request))), :active => true).group("homes.id").order(created_at: :desc)
    else
      render json: Home.home_joins.home_attributes.where(:user_id => Common.home_user(params[:user_id], User.user_id(token_and_options(request))), :active => true).group("homes.id, zillows.id").order(created_at: :desc)
    end
  end

  private

  def home_params
    _params = params.require(:home).permit(
      :id, :address, :address2, :city, :state, :zip, :price
    )
  end

  def home_params_update
    _params = params.require(:home).permit(
      :id, :price, :active
    )
  end
end
