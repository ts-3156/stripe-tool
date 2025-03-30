module Stripe
  class Callbacks
    class << self
      def run(event, target)
        Rails.logger.info target
      end
    end
  end
end