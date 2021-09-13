require 'rails_helper'

RSpec.describe 'Models requests', type: :request do
  before(:context) do
    @user_attr = FactoryBot.attributes_for(:user)
    @user = User.create!(@user_attr)
    @user.skip_confirmation!
    sign_in @user
    @created_models = FactoryBot.create_list(:model, 3) do |model, i|
      model.name = "Model #{i}"
    end
    @created_categories = FactoryBot.create_list(:category, 3) do |category, i|
      category.name = i
    end
    @json_api_headers = {**@user.create_new_auth_token, 'Content-Type': JSONAPI::MEDIA_TYPE}
  end
  it 'returns all models' do
    get '/models'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).fetch("data").count).to eq 3
  end

  describe 'Models CRUD' do
    before(:all) do
      params = {
        "data": {
          "type": "models",
          "attributes": {
            "name": "my new model",
            "ref": "xxxxxxxxxx",
            "description": "description text",
            "is_deal": false,
            "team": 1,
            "discount": 20,
            "price": 25,
            "deal_price": 20,
            "enabled": true,
            category_id: @created_categories.sample.id
          }
        }
      }.to_json
      post "/models", params: params, headers: @json_api_headers  
    end
    
    let(:model_id) { JSON.parse(response.body).fetch("data").fetch("id") }

    it 'create a new model' do
      expect(response).to have_http_status(:created), "Got a #{response.status}: #{response.body}"
      expect(Model.count).to eql(@created_models.count + 1)
    end
  
    it 'returns model by id' do
      get "/models/#{model_id}"
      expect(response).to have_http_status(:ok), "Got a #{response.status}: #{response.body}"
    end
  
    it 'updates a model' do
      params = {
        "data": {
          "id": model_id,
          "type": "models",
          "attributes": {
            name: "model test"
          }
        }
      }.to_json
      put "/models/#{model_id}", params: params, headers: @json_api_headers
      expect(response).to have_http_status(:ok), "Got a #{response.status}: #{response.body}"
    end

    it 'deletes a model' do
      count_before_delete = Model.count
      delete "/models/#{model_id}", headers: @json_api_headers
      expect(response).to have_http_status(:no_content), "Got a #{response.status}: #{response.body}"
      expect(Model.count).to eql(count_before_delete - 1)
    end
  
  end


end