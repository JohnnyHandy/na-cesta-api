class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_order, only: [:show, :update, :destroy]
  include Serializer
  # # GET /orders
  # def index
  #   @orders = Order.all

  #   render json: @orders, only: [:id, :created_at, :status, :ref], :include => {:user => {:only => :name}}
  # end

  # GET /orders/1
  def show
    serializer(OrderResource, @order, status: :ok, include: ['order_items'])
  end

  # # POST /orders
  # def create
  #   @order = Order.new(order_params)

  #   if @order.save
  #     puts @order
  #     if @order[:payment_method] === 'boleto'
  #       puts 'This is a boleto'
  #       OrdersMailer.boleto_email(@order, current_user).deliver
  #     end
  #     render json: @order, status: :created, location: @order
  #   else
  #     render json: @order.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /orders/1
  # def update
  #   if @order.update(order_params)
  #     render json: @order
  #   else
  #     render json: @order.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /orders/1
  # def destroy
  #   @order.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

  #   # Only allow a list of trusted parameters through.
  #   def order_params
  #     params.require(:order).permit(
  #       :status,
  #       :discount,
  #       :coupon,
  #       :total,
  #       :payment_type,
  #       :payment_id,
  #       :payment_method,
  #       :payment_status,
  #       :tracking_code,
  #       :ref,
  #       :user_id,
  #       :address_id,
  #       :boleto_pdf,
  #       order_items_attributes: [
  #         :name,
  #         :description,
  #         :is_deal,
  #         :color,
  #         :discount,
  #         :price,
  #         :deal_price,
  #         :size,
  #         :product_id,
  #         :quantity,
  #         :subtotal
  #       ]
  #     )
  #   end
end
