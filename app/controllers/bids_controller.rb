class BidsController < ApplicationController
  respond_to :json
  include ActionController::HttpAuthentication::Token
  before_filter :restrict_access, :only => [:create]

  def create
    bid = Bid.new(bid_params)
    bid.user_id = User.user_id(token_and_options(request))
    bid.home_id = params["home_id"]

    if bid.save
      Log.bid_create(bid.user_id,params,Home.find(params["home_id"]))
      render json: bid, status: :created, id: bid.home_id
    else
      render json: bid.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def show
    render json: Bid.joins(:user).bid_show_attributes.where(:home_id => params[:id])
  end

  def index
    render json: Bid.joins(:home).joins("LEFT JOIN images on images.home_id = bids.home_id").bid_index_attributes.where(:user_id => params[:user_id])
  end

  private

  def bid_params
    _params = params.require(:bid).permit(
      :price
    )
  end
end
