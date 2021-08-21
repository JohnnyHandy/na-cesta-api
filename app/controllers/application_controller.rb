class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include JSONAPI::ActsAsResourceController
        include ActiveStorage::SetCurrent
      end
