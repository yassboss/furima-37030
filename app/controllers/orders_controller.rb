class OrdersController < ApplicationController
  def index
    @order_address = OrderAddresses.new
  end
end
