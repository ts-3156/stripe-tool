class ActiveCheckoutSession < ApplicationRecord
  class << self
    def mark_as_expired(user_id)
      records = where(user_id: user_id).
          where(created_at: Stripe::CheckoutHandler::EXPIRY_MINUTES.minutes.ago..).
          where(expired_at: nil).
          where(completed_at: nil).
          order(created_at: :desc).
          limit(10).
          select(:id)
      jobs = records.map { |record| ExpireCheckoutSessionJob.new(record) }
      ActiveJob.perform_all_later(jobs)
    end

    def mark_as_completed(target_id)
      where(target_id: target_id).update_all(completed_at: Time.zone.now)
    end

    def cleanup
      where(created_at: ..Stripe::CheckoutHandler::EXPIRY_MINUTES.minutes.ago).delete_all
    end
  end
end
