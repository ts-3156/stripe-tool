module Stripe
  class CheckoutHandler
    PRICE_PAYMENT = ENV["PRICE_PAYMENT"]
    PRICE_SUBSCRIPTION = ENV["PRICE_SUBSCRIPTION"]
    PRICE_SETUP = ENV["PRICE_SETUP"]
    TAX_RATE = ENV["TAX_RATE"]

    class << self
      def build_params(mode, trial_period)
        email = "example#{(Time.zone.now + 9.hours).strftime('%H%M%S')}@example.com"
        customer = Stripe::Customer.create({email: email, metadata: {test: true}})
        expiry = 31.minutes.from_now.to_i

        if mode == "payment"
          {
              customer: customer.id,
              client_reference_id: 1,
              payment_method_types: ["card"],
              mode: "payment",
              line_items: [{price: PRICE_PAYMENT, tax_rates: [TAX_RATE], quantity: 1}],
              metadata: {test: true},
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
              metadata: {test: true},
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
