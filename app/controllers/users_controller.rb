class UsersController < ApplicationController
  respond_to :json
  include ActionController::HttpAuthentication::Token
  before_filter :restrict_access, :only => [:index, :show, :update]

  def create
    user = User.new(user_params)
    user.auth_token = User.auth_token
    user.active = true
    
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
    user = User.where(:id => params[:id], :auth_token => token_and_options(request)).first

    if user.blank?
      render json: { :errors => "Permission Denied" }, :status => :unprocessable_entity
    elsif user.update(user_params)
      render json: user, status: :created, auth_token: user.auth_token
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def index
    if params[:type] == 'message'
      render json: User.select("id,firstname,lastname").where("id IN (?)", eval(params['id']))
    else
      render json: User.all
    end
  end

  private

  def user_params
    _params = params.require(:user).permit(
      :email, :password, :password_confirmation, :firstname, :lastname, :active, :id, :password_digest, :created_at, :updated_at, :auth_token
    )
  end
end
