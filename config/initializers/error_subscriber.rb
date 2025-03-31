class ErrorSubscriber
  def initialize
    @logger = Logger.new("log/error.log")
  end

  def report(error, handled:, severity:, context:, source: nil)
    @logger.error error.message
    @logger.error error.backtrace.join("\n")
  end
end

Rails.error.subscribe(ErrorSubscriber.new)
