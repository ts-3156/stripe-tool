class User < ApplicationRecord
  include Stripe::Callbacks

  after_payment_intent_succeeded! do |payment_intent, event|
    customer = Stripe::Customer.retrieve(payment_intent.customer)
    StripeLog.create_callback_log!(payment_intent, event, customer.metadata[:user_id])
  end

  after_payment_intent_payment_failed! do |payment_intent, event|
    # 3D Secure Authentication Failed
    customer = Stripe::Customer.retrieve(payment_intent.customer)
    StripeLog.create_callback_log!(payment_intent, event, customer.metadata[:user_id])
  end

  after_charge_succeeded! do |charge, event|
    # TODO Validate user's state
    customer = Stripe::Customer.retrieve(charge.customer)
    StripeLog.create_callback_log!(charge, event, customer.metadata[:user_id])
  end

  after_charge_failed! do |charge, event|
    # Failed to enter card details or renew the subscription due to insufficient balance.
    # TODO Validate user's state
    customer = Stripe::Customer.retrieve(charge.customer)
    StripeLog.create_callback_log!(charge, event, customer.metadata[:user_id])
  end

  after_checkout_session_completed! do |checkout_session, event|
    # TODO Associate this event with an order
    ActiveCheckoutSession.mark_as_completed(checkout_session.id)
    StripeLog.create_callback_log!(checkout_session, event)
  end

  HANDLED_EVENT_TYPES = %w[
    payment_intent.succeeded
    payment_intent.payment_failed
    charge.succeeded
    charge.failed
    checkout.session.completed
  ]

  after_stripe_event do |target, event|
    if HANDLED_EVENT_TYPES.exclude?(event.type)
      StripeLog.create_callback_log!(target, event)
    end
  end
end
