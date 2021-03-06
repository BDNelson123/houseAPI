class Log
  include Mongoid::Document
  store_in collection: "log"

  field :user_id, :type => Integer
  field :home_id, :type => Integer
  field :type, :type => String
  field :action, :type => String
  field :address, :type => String
  field :address2, :type => String
  field :city, :type => String
  field :state, :type => String
  field :zip, :type => Integer
  field :price, :type => Integer
  field :date, :type => DateTime
  field :bid_price, :type => BigDecimal
  field :home_address, :type => String
  field :home_address2, :type => String
  field :home_city, :type => String
  field :home_state, :type => String
  field :home_zip, :type => Integer
  field :home_price, :type => BigDecimal

  def self.home_create(user_id,home_id,params)
    create(
      "user_id" => user_id,
      "type" => "home",
      "action" => "create",
      "date" => Time.now,
      "home_id" => home_id,
      "address" => params[:address],
      "address2" => params[:address2],
      "city" => params[:city],
      "state" => params[:state],
      "zip" => params[:zip],
      "price" => params[:price]
    )
  end

  def self.home_update(user_id,home)
    create(
      "user_id" => user_id,
      "type" => "home",
      "action" => "update",
      "date" => Time.now,
      "home_id" => home.id,
      "address" => home.address,
      "address2" => home.address2,
      "city" => home.city,
      "state" => home.state,
      "zip" => home.zip,
      "price" => home.price
    )
  end

  def self.bid_create(user_id,params,home)
    create(
      "user_id" => user_id,
      "type" => "bid",
      "action" => "create",
      "date" => Time.now,
      "home_id" => home.id,
      "home_address" => home.address,
      "home_address2" => home.address2,
      "home_city" => home.city,
      "home_state" => home.state,
      "home_zip" => home.zip,
      "home_price" => home.price,
      "bid_price" => params[:bid][:price]
    )
  end
end
