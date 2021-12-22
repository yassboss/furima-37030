class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :move_to_root_path

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number).merge(
      item_id: @item.id, user_id: current_user.id, token: params[:token], price: @item.price
    )
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: order_params[:price],
      card: order_params[:token],
      currency: 'jpy'
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_root_path
    redirect_to root_path if Order.find_by(item_id: params[:item_id]) || current_user.id == @item.user_id
  end
end
