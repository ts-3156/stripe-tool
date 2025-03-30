class User < ApplicationRecord
  include Stripe::Callbacks

  after_payment_intent_succeeded! do |payment_intent, event|
  end

  after_stripe_event do |target, event|
  end
end
