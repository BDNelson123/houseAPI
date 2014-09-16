class SessionsController < ApplicationController
  respond_to :json

  def show
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      render json: user, auth_token: user.auth_token, id: user.id
    else
      render json: "Your credentials were not found.  Please try again", :status => :unprocessable_entity
    end
  end

  def user_params
    _params = params.require(:user).permit(
      :email, :password, :password_confirmation
    )
  end
end
