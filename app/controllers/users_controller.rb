class UsersController < ApplicationController
  respond_to :json

  before_filter :restrict_access, :only => [:index, :show]

  def create
    user = User.new(user_params)
    user.auth_token = User.auth_token
    
    if user.save
      render json: user, status: :created, auth_token: user.auth_token, id: user.id
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by_id(params[:id])
    if user
      render json: user
    else
      render json: { :errors => "This user was not found." }, :status => :unprocessable_entity
    end
  end

  def update
    user = User.find_by_id(params[:id])

    if user.update(user_params)
      render json: user, status: :created, auth_token: user.auth_token
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: User.all
  end

  private

  def user_params
    _params = params.require(:user).permit(
      :email, :password, :password_confirmation, :auth_token, :id
    )
  end
end
