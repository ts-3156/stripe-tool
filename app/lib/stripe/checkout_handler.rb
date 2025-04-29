# TODO Rename
module Stripe
  class CheckoutHandler
    # Onetime payment
    #   Succeeded                    Failed
    #     payment_intent.succeeded     charge.failed
    #     checkout.session.completed   payment_intent.payment_failed
    #     charge.succeeded
    #
    # Subscription payment
    #   Succeeded                    Failed
    #     checkout.session.completed   charge.failed
    #     charge.succeeded             payment_intent.payment_failed
    #     payment_intent.succeeded
    #
    # Subscription with free trial payment
    #   Succeeded                    Failed
    #     setup_intent.created         setup_intent.created
    #     setup_intent.succeeded       setup_intent.setup_failed
    #     checkout.session.completed
    #
    # Subscription trial period ends
    #   Succeeded                    Failed
    #     charge.succeeded             charge.failed
    #     payment_intent.succeeded     payment_intent.payment_failed
    #
    # Subscription renewal
    #   Succeeded                    Failed
    #     payment_intent.succeeded     charge.failed
    #     charge.succeeded             payment_intent.payment_failed
    #
    # 3D secure
    #   Succeeded                      Failed
    #   payment_intent.requires_action   payment_intent.requires_action
    #   checkout.session.completed       payment_intent.payment_failed
    #   payment_intent.succeeded
    #   charge.succeeded

    PRICE_PAYMENT = ENV["PRICE_PAYMENT"]
    PRICE_SUBSCRIPTION = ENV["PRICE_SUBSCRIPTION"]
    PRICE_SETUP = ENV["PRICE_SETUP"]
    TAX_RATE = ENV["TAX_RATE"]
    EXPIRY_MINUTES = 31

    class << self
      def build_params(mode, trial_period, user, customer)
        expiry = EXPIRY_MINUTES.minutes.from_now.to_i

        if mode == "payment"
          {
              customer: customer.id,
              client_reference_id: user.id,
              payment_method_types: ["card"],
              mode: "payment",
              line_items: [{price: PRICE_PAYMENT, tax_rates: [TAX_RATE], quantity: 1}],
              metadata: {user_id: user.id},
              expires_at: expiry
          }
        elsif mode == "subscription"
          trial_period = /[1-3]/.match?(trial_period) ? trial_period.to_i : nil
          {
              customer: customer.id,
              client_reference_id: 1,
              mode: "subscription",
              line_items: [{price: PRICE_SUBSCRIPTION, quantity: 1}],
              subscription_data: {trial_period_days: trial_period, default_tax_rates: [TAX_RATE]}.compact,
              # discounts: '...',
              metadata: {user_id: user.id},
              expires_at: expiry
          }
        elsif mode == "setup"
          raise NotImplemented
        else
          raise
        end
      end
    end
  end
end
