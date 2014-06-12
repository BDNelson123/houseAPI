class HomesController < ApplicationController
  respond_to :json

  before_filter :restrict_access, :only => [:create, :update]

  def create
    home = Home.new(home_params)
    home.user_id = User.user_id(params[:home][:token])

    if home.save
      render json: home, status: :created, id: home.id
    else
      render json: home.errors, status: :unprocessable_entity
    end
  end

  def show
    if params[:image] == 'false'
      home = Home.find(params[:id])
    else
      home = Home.find(params[:id])
      home_total = Home.joins("LEFT JOIN images ON images.home_id = homes.id").select('homes.*,array_agg(images.image) AS images').where(:id => params[:id]).group("homes.id")
    end

    if home
      render json: home_total
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
    render json: Home.joins("LEFT JOIN images ON images.home_id = homes.id").select('homes.*,array_agg(images.image) AS images').where(:user_id => User.user_id(params[:token])).group("homes.id")
  end

  def destroy
    render json: Home.find_by_id(params[:id]).destroy
  end

  private

  def home_params
    _params = params.require(:home).permit(
      :id, :address, :address2, :city, :state, :zip
    )
  end
end
