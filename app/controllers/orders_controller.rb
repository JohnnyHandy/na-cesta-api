class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders, only: [:id, :created_at, :status], :include => {:user => {:only => :name}}
  end

  # GET /orders/1
  def show
    render json: @order, include: [:order_items, :user, :address]
  end

  # POST /orders
  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(
        :status,
        :discount,
        :coupon,
        :total,
        order_items_attributes: [
          :name,
          :description,
          :is_deal,
          :color,
          :discount,
          :price,
          :deal_price,
          :size,
          :product_id,
          :quantity,
          :subtotal
        ]
      )
    end
end
