class MessagesController < ApplicationController
  respond_to :json

  include ActionController::HttpAuthentication::Token

  before_filter :restrict_access, :only => [:create, :update, :destroy]

  def create
    message = Message.new(message_params)
    message.sender_id = User.user_id(token_and_options(request))
    
    if message.save
      render json: message, status: :created, id: message.id
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: Message.any_of({:sender_id => User.user_id(token_and_options(request)), :receiver_id => params[:user_id]}, {:sender_id => params[:user_id], :receiver_id => User.user_id(token_and_options(request))}).order_by("_id ASC")
  end

  private

  def message_params
    _params = params.require(:message).permit(
      :receiver_id, :home_id, :message
    )
  end
end
