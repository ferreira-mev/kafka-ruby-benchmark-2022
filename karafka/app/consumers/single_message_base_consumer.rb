# frozen_string_literal: true

# See https://karafka.io/docs/Consuming-messages/#one-at-a-time
class SingleMessageBaseConsumer < ApplicationConsumer
  attr_reader :message

  def consume
    messages.each do |message|
      @message = message
      consume_one

      mark_as_consumed(message)
    end
  end
end
