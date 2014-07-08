class LogsController < ApplicationController
  def show
    log = Log.where(:user_id => params[:id]).order_by(:date.desc)
    render json: log
  end
end
