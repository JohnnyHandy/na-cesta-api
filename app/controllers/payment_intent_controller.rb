class PaymentIntentController < ApplicationController
  def new
  end

  def create
    parsed_params = JSON.parse(payment_intent_params.to_json)
    payment_intent = Stripe::PaymentIntent.create(parsed_params)
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
      :receipt_email,
      :payment_method_types => []
    )
  end

end
