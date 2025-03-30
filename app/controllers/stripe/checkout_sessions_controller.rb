class Stripe::CheckoutSessionsController < ApplicationController

  PRICE_PAYMENT = ENV["PRICE_PAYMENT"]
  PRICE_SUBSCRIPTION = ENV["PRICE_SUBSCRIPTION"]
  PRICE_SETUP = ENV["PRICE_SETUP"]

  def new
  end

  def create
    if params[:mode] == "payment"
      price = PRICE_PAYMENT
      mode = "payment"
    elsif params[:mode] == "subscription"
      price = PRICE_SUBSCRIPTION
      mode = "subscription"
    else
      price = PRICE_SETUP
      mode = "setup"
    end

    options = {
        line_items: [{price: price, quantity: 1}],
        mode: mode,
        success_url: stripe_success_url,
        cancel_url: stripe_cancel_url
    }
    session = Stripe::Checkout::Session.create(options)
    redirect_to session.url, allow_other_host: true
  end

  def success
    render layout: false
  end

  def cancel
    render layout: false
  end
end
