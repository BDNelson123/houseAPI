class LogsController < ApplicationController
  def show
    render json: Log.where(:user_id => params[:id]).order_by(:date.desc)
  end
end
