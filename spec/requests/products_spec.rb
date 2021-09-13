require 'rails_helper'


RSpec.describe 'Products requests', type: :request do
  before(:context) do
    @user = User.all.sample
    @user.skip_confirmation!
    sign_in @user
    @created_products = FactoryBot.create_list(:product, 3, :with_stock) do |product|
      product.images = [fixture_file_upload(file_fixture('image.jpg'))]
    end
    @created_models = FactoryBot.create_list(:model, 3)
    @image_files = fixture_file_upload(file_fixture('image.jpg'))
    @stocks_attributes = FactoryBot.attributes_for(:stock)
    @auth_headers = @user.create_new_auth_token
    @multipart_headers = {**@auth_headers, 'Content-Type': 'multipart/form-data'}
    @json_api_headers = {**@auth_headers, 'Content-Type': JSONAPI::MEDIA_TYPE}
  end

  it 'returns all products' do
    get '/products'
    expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
  end

  describe 'Product CRUD + images and stocks update/delete' do
    before(:all) do
      @count = Product.count
      params = {
        "data": {
          "type": "models",
          "attributes": {
            "name": "my new product",
            "ref": "xxxxxxxxxx",
            "description": "description text",
            "is_deal": false,
            "team": 1,
            "discount": 20,
            "price": 25,
            "deal_price": 20,
            "enabled": true,
            model_id: @created_models.sample.id,
            images: [@image_files],
            stocks_attributes: [@stocks_attributes]
          }
        }
      }
      post "/products", params: params, headers: @multipart_headers
      @product_id = JSON.parse(response.body).fetch("data").fetch("id")
      @current_product = Product.find(@product_id)
    end

      let(:current_product) { @current_product }
      let(:product_id) { @product_id }

      it 'creates a new product' do
        expect(response).to have_http_status(:created), "Got a #{response.status}: #{response.body}"
        expect(Product.count).to eql(@count + 1)
        expect(current_product.images).to be_attached
      end

      it 'returns a product by id' do
        get "/products/#{product_id}", headers: @json_api_headers
        expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
      end
  
    describe 'working with attached images' do
      it 'updates attached image filename' do
        imageId = current_product.images.sample.id
        params = {
          "data": {
            "type": "images",
            "attributes": {
              "filename": "new filename"
            }
          }
        }.to_json
        patch "/products/#{product_id}/image/#{imageId}", params: params, headers: @json_api_headers
        expect(response).to have_http_status(:ok),"Got a #{response.status}: #{response.body}"
      end
      it 'purges attached image' do
        imageId = current_product.images.sample.id
  
        delete "/products/#{product_id}/image/#{imageId}", headers: @json_api_headers
        expect(response).to have_http_status(:no_content),"Got a #{response.status}: #{response.body}"
      end  
    end

    describe 'working with stocks' do
      it 'updates product stock' do
        stockId = current_product.stocks.sample.id
        params = {
          "data": {
            "type": "stocks",
            "attributes": {
              "size": "M",
              "quantity": 20
            }
          }
        }.to_json
        patch "/products/#{product_id}/stock/#{stockId}", params: params, headers: @json_api_headers
        expect(response).to have_http_status(:ok),"Got a #{response.status}: #{response.body}"
      end
      it 'deletes product stock' do
        stockId = current_product.stocks.sample.id

        delete "/products/#{product_id}/stock/#{stockId}", headers: @json_api_headers
        expect(response).to have_http_status(:no_content),"Got a #{response.status}: #{response.body}"
      end

    end
    it 'updates a product' do
      params = {
        "data": {
          "id": product_id,
          "type": "products",
          "attributes": {
            "name": "my new edited",
            "ref": "editedxxxxxxxxxx",
            "description": "edited description text",
            "is_deal": false,
            "team": 2,
            "discount": 3,
            "price": 50,
            "deal_price": 25,
            "enabled": false,
            model_id: @created_models.sample.id,
            images: [@image_files]
          }
        }
      }
      put "/products/#{product_id}", params: params, headers: @multipart_headers
      expect(response).to have_http_status(:created), "Got a #{response.status}: #{response.body}"
    end

    it 'deletes a product' do
      count_before_delete = Product.count
      delete "/products/#{product_id}", headers: @auth_headers
      expect(response).to have_http_status(:no_content), "Got a #{response.status}: #{response.body}"
      expect(Product.count).to eql(count_before_delete - 1)
    end  
  end
end