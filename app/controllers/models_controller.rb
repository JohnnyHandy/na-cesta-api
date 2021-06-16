class ModelsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_model, only: [:show, :update, :destroy]

  # GET /models
  def index
   
    @q = Model.ransack(params[:q])
    puts params[:q]
    @models = @q.result
    render json: @models
  end

  # GET /models/1
  def show
    render json: @model
  end

  # POST /models
  def create
    @model = Model.new(model_params)

    if @model.save
      render json: @model, status: :created, location: @model
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /models/1
  def update
    if @model.update(model_params)
      render json: @model
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  end

  # DELETE /models/1
  def destroy
    @model.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = Model.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def model_params
      params.require(:model).permit(
        :ref,
        :name,
        :category_id,
        :description,
        :is_deal,
        :discount,
        :price,
        :deal_price,
        :enabled,
      )
    end
end
