require 'rails_helper'


RSpec.describe 'Categories request', type: :request do
  before(:context) do
    @created_categories = FactoryBot.create_list(:category, 3) do |category, i|
      category.name = i
    end
    @json_api_headers = { 'Content-Type': JSONAPI::MEDIA_TYPE }

  end
  it 'returns all categories' do
    get '/categories', headers: @json_api_headers
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).fetch("data").count).to eq 3
  end

  describe 'Categories CRUD' do

    before(:all) do
      params = {
        "data": {
          "type": "categories",
          "attributes": {
            name: "regata"
          }
        }
      }.to_json
      post "/categories", params: params, headers: @json_api_headers
    end

    let(:category_id) { JSON.parse(response.body).fetch("data").fetch("id") }

    it 'create a new category' do
      expect(response).to have_http_status(:created), "Got a #{response.status}: #{response.body}"
      expect(Category.count).to eql(@created_categories.count + 1)
    end

    it 'returns category by id' do
      get "/categories/#{category_id}"
      expect(response).to have_http_status(:ok), "Got a #{response.status}: #{response.body}"
    end  

    it 'updates a category' do
      params = {
        "data": {
          "id": category_id,
          "type": "categories",
          "attributes": {
            name: "shorts"
          }
        }
      }.to_json
      put "/categories/#{category_id}", params: params, headers: @json_api_headers
      expect(response).to have_http_status(:ok), "Got a #{response.status}: #{response.body}"
    end
  
    it 'deletes a category' do
      count_before_delete = Category.count
  
      delete "/categories/#{category_id}"
      expect(response).to have_http_status(:no_content), "Got a #{response.status}: #{response.body}"
      expect(Category.count).to eql(count_before_delete - 1)
    end
  
  end


end