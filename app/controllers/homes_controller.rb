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
    home = Home.find_by_id(params[:id])
    if home
      render json: home
    else
      render json: { :errors => "This home was not found." }, :status => :unprocessable_entity
    end
  end

  def update
    home = Home.find_by_id(params[:id])

    if home.update(home_params_update)
      render json: home, status: :created, id: home.id
    else
      render json: home.errors, status: :unprocessable_entity
    end
  end

  private

  def home_params
    _params = params.require(:home).permit(
      :id, :address, :address2, :city, :state, :zip
    )
  end

  def home_params_update
    _params = params.fetch(:image, {}).permit(
      :id, :address, :address2, :city, :state, :zip
    )
  end
end
