class UsersController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  def index
    @users = User.all
    render json: @users, include: :addresses
  end
  def set_product
    @product = Product.find(params[:id])
  end
end
