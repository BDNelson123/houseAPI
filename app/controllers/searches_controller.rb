class SearchesController < ApplicationController
  def index
    search = Home.paginate(:page => params[:page], :per_page => 10).home_searches_join.home_searches_select.where('address ilike ? OR address2 ilike ? OR city ilike ? OR state ilike ? OR cast(zip as text) ilike ?', "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")

    if params["count"] == "true"
      render json: [[search.count.to_i]]
    else
      render json: search.group("homes.id,zillows.id,images.id")
    end
  end
end
