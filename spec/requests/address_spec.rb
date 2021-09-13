require 'rails_helper'

RSpec.describe 'Addresses requests', type: :request do

  before(:context) do
    @user_attr = FactoryBot.attributes_for(:user)
    @user = User.create!(@user_attr)
    @user.skip_confirmation!
    sign_in @user
    @created_addresses = FactoryBot.create_list(:address, 3)
    @json_api_headers = {**@user.create_new_auth_token, 'Content-Type': JSONAPI::MEDIA_TYPE }
  end

  let(:created_addresses) { @created_addresses }

  it 'returns all addresses' do
    get '/addresses', headers: @json_api_headers
    expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
  end

  describe 'Address CRUD' do

    before(:all) do
      params = {
        "data": {
          "type": "addresses",
          "attributes": {**FactoryBot.attributes_for(:address), user_id: @user.id}
        }
      }.to_json
      post '/addresses', params: params, headers: @json_api_headers  
    end

    let(:address_id) { JSON.parse(response.body).fetch("data").fetch("id") }

    it 'creates an address' do
      expect(response).to have_http_status(:created),  "Got a #{response.status}: #{response.body}"
      expect(Address.count).to eql(created_addresses.count + 1)
    end

    it 'returns an address by id' do
      get "/addresses/#{address_id}", headers: @json_api_headers
      expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
    end
    
    it'updates an address' do
      params = {
        "data": {
          "id": address_id,
          "type": "addresses",
          "attributes": {**FactoryBot.attributes_for(:address)}
        }
      }.to_json
      put "/addresses/#{address_id}", params: params, headers: @json_api_headers
      expect(response).to have_http_status(:ok),  "Got a #{response.status}: #{response.body}"
    end

    it 'deletes an address' do
      count_before_delete = Address.count
      delete "/addresses/#{address_id}", headers: @json_api_headers
      expect(response).to have_http_status(:no_content),  "Got a #{response.status}: #{response.body}"
      expect(Address.count).to eql(count_before_delete - 1)
    end
  end

end