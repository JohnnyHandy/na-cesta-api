class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update, :destroy]
  def index
    @users = User.all
    render json: @users
  end
  def show
    render json: @user,  include: [:addresses]
  end
  def set_user
    @user = User.find(params[:id])
  end
end
