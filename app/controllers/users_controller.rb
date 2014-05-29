class UsersController < ApplicationController
  respond_to :json

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: @user
    else
      render json: false
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
