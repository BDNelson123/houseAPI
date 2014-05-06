class UsersController < ApplicationController
  respond_to :json

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      render json: @user
    else
      render json: "error"
    end
  end

  def index
    render json: User.all
  end

  def user_params
    _params = params.require(:user).permit(
      :email, :password, :password_confirmation
    )
  end
end
