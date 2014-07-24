class MessagesController < ApplicationController
  respond_to :json
  include ActionController::HttpAuthentication::Token
  before_filter :restrict_access, :only => [:create, :show, :index]

  def create
    message = Message.new(message_params)
    message.sender_id = User.user_id(token_and_options(request))
    message.thread_id = Message.thread_id(User.user_id(token_and_options(request)), message_params['receiver_id'])

    if message.save
      render json: message, status: :created, id: message.id
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  def index
    if params[:home_id]
      render json: Message.any_of(
        {:sender_id => User.user_id(token_and_options(request)), :receiver_id => params[:user_id], :home_id => params[:home_id]}, 
        {:sender_id => params[:user_id], :receiver_id => User.user_id(token_and_options(request)), :home_id => params[:home_id]}
      ).order_by("_id ASC")
    elsif params[:type] == 'all'
      render json: Message.collection.aggregate(
        {
          "$match" => {
            "$or" => [
              {:sender_id => User.user_id(token_and_options(request))},
              {:receiver_id => User.user_id(token_and_options(request))}
            ]
          }
        },
        {
          "$group" => { 
            _id: { :thread_id => "$thread_id" }, 
            "message" => { "$last" => "$message" },
            "sender_id" => { "$last" => "$sender_id" },
            "receiver_id" => { "$last" => "$receiver_id" }
          }
        }
      )
    end
  end

  private

  def message_params
    _params = params.require(:message).permit(
      :receiver_id, :home_id, :message
    )
  end
end
