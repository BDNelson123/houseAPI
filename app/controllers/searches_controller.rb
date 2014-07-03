class SearchesController < ApplicationController
  def index
    render json: Home.joins("LEFT JOIN images ON images.home_id = homes.id AND images.primary = true").select('homes.*,array_agg(images.image) AS images').where('address ilike ? OR address2 ilike ? OR city ilike ? OR state ilike ? OR cast(zip as text) ilike ?', "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%").group("homes.id")
  end
end
