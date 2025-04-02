class Stripe::CheckoutSessionsController < ApplicationController
  def new
    @user = Current.user
  end

  def create
    user = create_user
    customer = create_stripe_customer(user)
    options = Stripe::CheckoutHandler.build_params(params[:mode], params[:trial_period], user, customer).
        merge(success_url: stripe_success_url, cancel_url: stripe_cancel_url)

    ActiveCheckoutSession.mark_as_expired(user.id)
    session = Stripe::Checkout::Session.create(options)
    ActiveCheckoutSession.create!(user_id: user.id, target_id: session.id)

    redirect_to session.url, allow_other_host: true
  end

  def success
  end

  def cancel
  end

  private

  def create_user
    User.create!(email_address: "example#{(Time.zone.now + 9.hours).strftime('%H%M%S')}@example.com", password: '1234')
  end

  def create_stripe_customer(user)
    Stripe::Customer.create({email: user.email_address, metadata: {user_id: user.id}})
  end
end
