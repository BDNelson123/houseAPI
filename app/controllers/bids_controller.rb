class BidsController < ApplicationController
  respond_to :json

  include ActionController::HttpAuthentication::Token

  before_filter :restrict_access

  def create
    bid = User.new(bid_params)
    user.auth_token = User.auth_token
    
    if user.save
      render json: user, status: :created, auth_token: user.auth_token, id: user.id
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def bid_params
    _params = params.require(:user).permit(
      :price
    )
  end
end
