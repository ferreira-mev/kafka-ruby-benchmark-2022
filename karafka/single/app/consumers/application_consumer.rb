# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationConsumer < Karafka::BaseConsumer
  # See https://karafka.io/docs/Consuming-messages/#one-at-a-time
  attr_reader :message

  def consume
    messages.each do |message|
      @message = message
      consume_one
    end

    # This could be moved into the loop but would slow down the processing, it is a trade-off
    # between retrying the batch and processing performance
    mark_as_consumed(messages.last)
  end
end
