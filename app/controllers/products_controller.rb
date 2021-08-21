class ProductsController < ApplicationController
  include Serializer
  before_action :authenticate_user!, only: [:create, :update, :destroy, :update_filename, :purge_image]
  before_action :set_product, only: [:show, :update, :destroy]
#   # GET /products
  def index
    products = params[:model_id] ?
      Product.where(model_id: params[:model_id]) :
      Product.all
    idsArray = []
    products.each { |product|  idsArray << product.id }  
    render status: 200, json: json_resources(ProductResource, products, idsArray, nil)
  end

  # GET /products/1
  def show
    serializer(ProductResource, @product, status: :ok, include: ['stocks', 'images'])
  end

#   # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      serializer(ProductResource, @product, status: :created)
    else
      error_serializer(@product.errors, status: :unprocessable_entity)
    end
  end

  def update
    if @product.update(product_params)
      serializer(ProductResource, @product, status: :created)
    else
      error_serializer(@product.errors, status: :unprocessable_entity)
    end
  end


#   # DELETE /products/1
  def destroy
    @product.destroy
  end

  #PATCH /products/1/image/1
  def update_filename
    product = Product.find(params[:product_id])
    image = product.images.find(params[:image_id])
    if image.update(product_params)
      serializer(ImageResource, image, status: :ok)
    else
      error_serializer(image.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /products/1/image/1
  def purge_image
    product = Product.find(params[:product_id])
    product.images.find(params[:image_id]).purge
    head :created
  end

#PATCH /products/1/stocks/1
  def update_stock
    product = Product.find(params[:product_id])
    stock = product.stocks.find(params[:stock_id])
    stock.update!(stock_params)
    if stock.update(product_params)
      serializer(StockResource, stock, status: :ok)
    else
      error_serialize(stock.errors, status: :unprocessable_entity)
    end
  end
# DELETE /products/1/stock/1
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
      params.require(:data)
            .require(:attributes)
            .permit(
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
              :filename,
              stocks_attributes: [
                :size,
                :quantity
              ],
              images:[]
            )
    end

    def stock_params
      params.require(:data)
      .require(:attributes)
      .permit(:size, :quantity)
    end
end
