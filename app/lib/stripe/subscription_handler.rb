# TODO Rename
module Stripe
  class SubscriptionHandler
    class << self
      def trial_end_now(subscription_id)
        Stripe::Subscription.update(subscription_id, trial_end: "now")
      end

      def cancel_now(subscription_id)
        Stripe::Subscription.cancel(subscription_id)
      end
    end
  end
end
