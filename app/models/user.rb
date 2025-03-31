class User < ApplicationRecord
  include Stripe::Callbacks

  after_payment_intent_succeeded! do |payment_intent, event|
    logger.warn event.type
  end

  after_checkout_session_completed! do |checkout_session, event|
    logger.warn event.type
  end

  after_stripe_event do |target, event|
    if %w[payment_intent.succeeded checkout.session.completed].exclude?(event.type)
      logger.info "Unprocessed: #{event.type}"
    end
  end
end
