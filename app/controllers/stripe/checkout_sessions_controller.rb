class Stripe::CheckoutSessionsController < ApplicationController
  def new
  end

  def create
    user = User.create!(email: "example#{(Time.zone.now + 9.hours).strftime('%H%M%S')}@example.com")
    customer = Stripe::Customer.create({email: user.email, metadata: {user_id: user.id}})
    # TODO Run in background
    ActiveCheckoutSession.mark_as_expired(user.id)
    options = Stripe::CheckoutHandler.build_params(params[:mode], params[:trial_period], user, customer)
    options.merge!(success_url: stripe_success_url, cancel_url: stripe_cancel_url)
    session = Stripe::Checkout::Session.create(options)
    ActiveCheckoutSession.create!(user_id: user.id, target_id: session.id)
    redirect_to session.url, allow_other_host: true
  end

  def success
  end

  def cancel
  end
end
