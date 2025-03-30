class Stripe::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # event = Stripe::Event.retrieve(params[:id])
    event = construct_event
    Stripe::Callbacks.run(event, event.data.object)
    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError => e
    logger.error e.inspect
    head :bad_request
  end

  private

  def construct_event
    payload = request.body.read
    sig_header = request.headers['HTTP_STRIPE_SIGNATURE']
    Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_ENDPOINT_SECRET'])
  end
end
