require 'rails_helper'

RSpec.describe 'Orders requests', type: :request do
  before(:context) do
    @user_attr = FactoryBot.attributes_for(:user)
    @user = User.create!(@user_attr)
    @user.skip_confirmation!
    sign_in @user
    @address = FactoryBot.create(:address, user_id: @user.id)
    @created_orders = FactoryBot.create_list(:order, 3, :with_order_item) do |order|
      order.address_id = @address.id
      order.user_id = @user.id
    end
    @json_api_headers = {**@user.create_new_auth_token, 'Content-Type': JSONAPI::MEDIA_TYPE }
  end

  it 'returns all orders' do
    get '/orders', headers: @json_api_headers
    expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
  end

  describe 'Orders CRUD' do
    before(:all) do
      @order_attributes = FactoryBot.attributes_for(:order_item)
      params = {
        "data": {
          "type": "orders",
          "attributes": {
            **FactoryBot.attributes_for(:order),
            user_id: @user.id,
            address_id: @address.id,
            order_items_attributes: [{
              **@order_attributes.slice(
                :name,
                :color,
                :size,
                :description,
                :is_deal,
                :discount,
                :price,
                :deal_price,
                :quantity,
                :subtotal,
              ),
              product_id: @order_attributes[:product][:id]
            }]
          }
        }
      }.to_json
      post '/orders', params: params, headers: @json_api_headers  
    end

    let(:order_id) { JSON.parse(response.body).fetch("data").fetch("id") }

    it 'creates an order' do
      expect(response).to have_http_status(:created),  "Got a #{response.status}: #{response.body}"
      expect(Order.count).to eql(@created_orders.count + 1)
    end

    it 'returns an order by id' do
      get "/orders/#{order_id}", headers: @json_api_headers
      expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
    end


    it'updates an order' do
      params = {
        "data": {
          "id": order_id,
          "type": "orders",
          "attributes": {
            **FactoryBot.attributes_for(:order),
            user_id: @user.id,
            address_id: @address.id,
            order_items_attributes: [{
              **@order_attributes.slice(
                :name,
                :color,
                :size,
                :description,
                :is_deal,
                :discount,
                :price,
                :deal_price,
                :quantity,
                :subtotal,
              ),
              product_id: @order_attributes[:product][:id]
            }]
          }
        }
      }.to_json
      put "/orders/#{order_id}", params: params, headers: @json_api_headers
      expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
    end

    it 'deletes an order' do
      count_before_delete = Order.count
      delete "/orders/#{order_id}", headers: @json_api_headers
      expect(response).to have_http_status(:no_content),  "Got a #{response.status}: #{response.body}"
      expect(Order.count).to eql(count_before_delete - 1)
    end

  end

end
