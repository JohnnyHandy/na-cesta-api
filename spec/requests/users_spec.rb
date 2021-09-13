require 'rails_helper'

RSpec.describe 'Auth and user requests', type: :request do

  before(:context) do
    @user_attr = FactoryBot.attributes_for(:user, :with_address)
    @initialUserCount = User.count
    params = {
      "data": {
        "type": "registrations",
        "attributes": {**@user_attr}
      }
    }
    post '/auth', params: params
    @created_user_id = JSON.parse(response.body).fetch("data").fetch("id")
  end

  let(:user_id) { @created_user_id }
  describe 'User sign up' do
    it 'Tries to sign up user' do
      expect(response).to have_http_status(:created),"Got a #{response.status}: #{response.body}"
      expect(User.count).to eql(@initialUserCount + 1)
    end
  end

  describe 'Tries to login, update and logout user' do

    before (:all) do
      @user = User.find(@created_user_id)
      @user.confirm
      @auth_headers = @user.create_new_auth_token
    end

    let(:user) {@user}
    let(:auth_headers) {@auth_headers}

    it 'Tries to log user in' do
      params = {
        email: @user_attr[:email],
        password: @user_attr[:password]
      }
      post '/auth/sign_in', params: params
      expect(response).to have_http_status(:ok),"Got a #{response.status}: #{response.body}"
    end

    it 'Update user' do
      params = {
        "data": {
          id: user.id,
          "type": "users",
          "attributes": {
            "document": "1234567890"
          }
        }
      }
      put "/users/#{user.id}", params: params, headers: auth_headers
      expect(response).to have_http_status(:ok),"Got a #{response.status}: #{response.body}"
    end

    it "Tries to log out" do
      delete '/auth/sign_out', headers: auth_headers
      expect(response).to have_http_status(:ok),"Got a #{response.status}: #{response.body}"
    end

  end
  
end