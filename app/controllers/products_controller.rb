class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :update_filename, :purge_image]
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = params[:model_id] ?
      Product.where(model_id: params[:model_id]) :
       Product.all

    render json: @products, include: [:stocks], methods: :image_url
  end

  # GET /products/1
  def show
    render json: @product, include: [:stocks], methods: :image_url
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  #PATCH /produtcs/1/image/1
  def update_filename
    product = Product.find(params[:product_id])
    image = product.images.find(params[:image_id])
    image.update!(product_params)
    render json: {
      id: image.id,
      filename: image.filename,
      url: image.url
    }
  end

  # DELETE /products/1/image/1
  def purge_image
    product = Product.find(params[:product_id])
    product.images.find(params[:image_id]).purge
    head :created
  end

#PATCH /stocks/1/image/1
  def update_stock
    product = Product.find(params[:product_id])
    stock = product.stocks.find(params[:stock_id])
    stock.update!(stock_params)
    render json: {
      id: stock.id,
      size: stock.size,
      quantity: stock.quantity
    }
  end
# DELETE /products/1/image/1
  def purge_stock
    product = Product.find(params[:product_id])
    product.stocks.find(params[:stock_id]).destroy
    head :no_content
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.permit(
        :name,
        :ref,
        :color,
        :description,
        :is_deal,
        :discount,
        :price,
        :deal_price,
        :enabled,
        :model_id,
        stocks_attributes: [
          :size,
          :quantity
        ],
        images:[]
      )
    end

    def stock_params
      params.permit(:size, :quantity)
    end
end
