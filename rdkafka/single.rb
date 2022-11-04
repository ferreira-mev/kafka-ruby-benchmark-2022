# frozen_string_literal: true

require 'rdkafka'
require 'csv'

ROW_ID = 'rdkafka-single'
RESULTS_PATH = 'results.csv'

config = {
  :"bootstrap.servers" => "localhost:9092",
  :"group.id" => "kafka-bench"
}

consumer = Rdkafka::Config.new(config).consumer
consumer.subscribe("kafka_bench_json")

consumer.each do |_message|
  @count ||= 0
  @starting_time = Time.now if @count.zero?
  @count += 1

  next unless @count >= 100_000

  time_taken = Time.now - @starting_time

  puts "#{ROW_ID} read #{@COUNT} messages in #{time_taken}"

  CSV.open(RESULTS_PATH, 'a') do |csv|
    csv << [ROW_ID, time_taken, @count]
  end

  @count = 0
end
