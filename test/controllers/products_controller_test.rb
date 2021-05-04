require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url, as: :json
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: { color: @product.color, deal_price: @product.deal_price, description: @product.description, discount: @product.discount, enabled: @product.enabled, in_stock: @product.in_stock, is_deal: @product.is_deal, name: @product.name, price: @product.price, size: @product.size } }, as: :json
    end

    assert_response 201
  end

  test "should show product" do
    get product_url(@product), as: :json
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { color: @product.color, deal_price: @product.deal_price, description: @product.description, discount: @product.discount, enabled: @product.enabled, in_stock: @product.in_stock, is_deal: @product.is_deal, name: @product.name, price: @product.price, size: @product.size } }, as: :json
    assert_response 200
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product), as: :json
    end

    assert_response 204
  end
end
