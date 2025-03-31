class Stripe::CheckoutSessionsController < ApplicationController
  def new
  end

  def create
    # TODO Expire other sessions
    options = Stripe::CheckoutHandler.build_params(params[:mode], params[:trial_period])
    options.merge!(success_url: stripe_success_url, cancel_url: stripe_cancel_url)
    session = Stripe::Checkout::Session.create(options)
    redirect_to session.url, allow_other_host: true
  end

  def success
  end

  def cancel
  end
end
