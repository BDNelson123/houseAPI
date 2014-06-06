class HomesController < ApplicationController
  respond_to :json

  before_filter :restrict_access, :only => [:create, :new]

  def new
  end

  def create
    home = Home.new(home_params)
    home.user_id = User.user_id(params[:home][:token])

    if home.save
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
end
