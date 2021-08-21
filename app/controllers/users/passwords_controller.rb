# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  include Serializer
  
  def create
    self.resource = resource_class.send_reset_password_instructions(request_password_reset_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      head :ok
    else
      error_serializer(resource.errors, status: :unprocessable_entity)
    end
  end
  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(update_password_params)
    yield resource if block_given?

    if resource.errors.empty?
      head :ok
    else
      error_serializer(resource.errors, status: :unprocessable_entity)
    end
  end

  private
  def request_password_reset_params
    params.require(:data).require(:attributes).permit(:email, :redirect_url)
  end
  def update_password_params
    params.require(:data).require(:attributes).permit( :password, :password_confirmation, :reset_password_token)
  end
end
