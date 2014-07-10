class BidsController < ApplicationController
  respond_to :json
  include ActionController::HttpAuthentication::Token
  before_filter :restrict_access, :only => [:create]

  def create
    bid = Bid.new(bid_params)
    bid.user_id = User.user_id(token_and_options(request))
    bid.home_id = params["home_id"]

    if bid.save
      render json: bid, status: :created, id: bid.home_id
    else
      render json: bid.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: Bid.joins(:user).select("*").where(:home_id => params[:id])
  end

  def index
    render json: Bid.joins(:home).joins("LEFT JOIN images on images.home_id = bids.home_id").bid_attributes.where(:user_id => params[:user_id])
  end

  private

  def bid_params
    _params = params.require(:bid).permit(
      :price
    )
  end
end
