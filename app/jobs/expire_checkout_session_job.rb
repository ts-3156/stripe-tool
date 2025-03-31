class ExpireCheckoutSessionJob < ApplicationJob
  queue_as :default

  def perform(checkout_session)
    if Stripe::Checkout::Session.retrieve(checkout_session.target_id).status == "open"
      Stripe::Checkout::Session.expire(checkout_session.target_id)
      checkout_session.update!(expired_at: Time.zone.now)
    end
  end
end
