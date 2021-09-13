class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_order, only: [:show, :update, :destroy]
  include Serializer
  # # GET /orders
  def index
    q = Order.ransack(params[:q])
    orders = q.result.paginate(page: params[:page], per_page: params[:per_page])
    idsArray = []
    orders.each { |order|  idsArray << order.id }
    render status: 200,
      json: json_resources(
        OrderResource,
        orders,
        idsArray,
        {
          pagination:
          {
            page: params[:page],
            per_page: params[:per_page],
            total: q.result.count
          }
        }
      )
  end

  # GET /orders/1
  def show
    render status: 200, json: json_resources(OrderResource, @order, @order.id)
  end

  # # POST /orders
  def create
    @order = Order.new(order_params)
    if @order.save
      if @order[:payment_method] === 'boleto'
        OrdersMailer.boleto_email(@order, current_user).deliver
      end
      render status: :created, json: json_resources(OrderResource, @order, @order.id)
    else
      error_serializer(@order.errors, status: :unprocessable_entity)
    end
  end

  # # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render status: :ok, json: json_resources(OrderResource, @order, @order.id)
    else
      error_serializer(@order.errors, status: :unprocessable_entity)
    end
  end

  # # DELETE /orders/1
  # def destroy
  #   @order.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:data)
            .require(:attributes)
            .permit(
              :status,
              :discount,
              :coupon,
              :total,
              :payment_type,
              :payment_id,
              :payment_method,
              :payment_status,
              :tracking_code,
              :ref,
              :user_id,
              :address_id,
              :boleto_pdf,
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
