class Log
  include Mongoid::Document
  store_in collection: "log"

  field :user_id, :type => Integer
  field :type, :type => String
  field :action, :type => String
  field :address, :type => String
  field :address2, :type => String
  field :city, :type => String
  field :state, :type => String
  field :zip, :type => Integer
  field :price, :type => Integer

  def self.home_create(user_id,home_id,params)
    create(
      "user_id" => user_id,
      "type" => "home",
      "action" => "create",
      "id" => home_id,
      "address" => params[:address],
      "address2" => params[:address2],
      "city" => params[:city],
      "state" => params[:state],
      "zip" => params[:zip],
      "price" => params[:price]
    )
  end

  def self.home_update(user_id,home_id,price)
    create(
      "user_id" => user_id,
      "type" => "home",
      "action" => "update",
      "id" => home_id,
      "price" => price
    )
  end
end
