class PaymentIntentController < ApplicationController
  def new
  end

  def create
    puts JSON.parse(payment_intent_params.to_json)
    payment_intent = Stripe::PaymentIntent.create(
      JSON.parse(payment_intent_params.to_json)
    )
    render json: payment_intent
  end
  private
  def payment_intent_params
    params.require('payment_intent').permit(
      :amount,
      :currency,
      :paymentMethodType,
      :paymentMethod,
      :payment_method,
      :payment_intent,
      :confirm,
      :id,
      :payment_method_types => []
    )
  end

end
