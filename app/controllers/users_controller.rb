class UsersController < ApplicationController
  respond_to :json

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: User.all
  end

  private

  def user_params
    _params = params.require(:user).permit(
      :email, :password, :password_confirmation
    )
  end
end
