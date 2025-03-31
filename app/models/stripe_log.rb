class StripeLog < ApplicationRecord
  class << self
    def create_callback_log!(target, event, user_id = nil)
      create!(
          user_id: user_id || target.metadata[:user_id],
          event_type: event.type,
          target_id: target.id,
          event_id: event.id
      )
    end
  end
end
