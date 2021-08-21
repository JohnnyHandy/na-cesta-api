class PasswordResource < JSONAPI::Resource
  attributes :email, :password, :password_confirmation, :reset_password_token
end
