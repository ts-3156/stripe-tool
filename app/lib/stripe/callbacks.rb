require_relative "callbacks/builder"

module Stripe
  module Callbacks
    include Callbacks::Builder

    callback "charge.captured"
    callback "charge.failed"
    callback "charge.pending"
    callback "charge.refunded"
    callback "charge.succeeded"
    callback "charge.updated"
    callback "checkout.session.async_payment_failed"
    callback "checkout.session.async_payment_succeeded"
    callback "checkout.session.completed"
    callback "checkout.session.expired"
    callback "order.created"
    callback "order.payment_failed"
    callback "order.payment_succeeded"
    callback "order.updated"
    callback "order_return.created"
    callback "payment_intent.amount_capturable_updated"
    callback "payment_intent.canceled"
    callback "payment_intent.created"
    callback "payment_intent.payment_failed"
    callback "payment_intent.processing"
    callback "payment_intent.requires_action"
    callback "payment_intent.succeeded"
    callback "payment_method.attached"
    callback "payment_method.card_automatically_updated"
    callback "payment_method.detached"
    callback "payment_method.updated"
    callback "ping"
    callback "stripe.event"

    class << self
      def run_callbacks(evt, target)
        _run_callbacks evt.type, evt, target
        _run_callbacks "stripe.event", evt, target
      end

      def _run_callbacks(type, evt, target)
        run_critical_callbacks type, evt, target
        run_noncritical_callbacks type, evt, target
      end

      def run_critical_callbacks(type, evt, target)
        ::Stripe::Callbacks.critical_callbacks[type].each do |callback|
          callback.call(target, evt)
        end
      end

      def run_noncritical_callbacks(type, evt, target)
        ::Stripe::Callbacks.noncritical_callbacks[type].each do |callback|
          begin
            callback.call(target, evt)
          rescue Exception => e
            ::Rails.logger.error e.message
            ::Rails.logger.error e.backtrace.join("\n")
          end
        end
      end
    end
  end
end
