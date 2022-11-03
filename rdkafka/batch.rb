# frozen_string_literal: true

require 'rdkafka'
require 'csv'

ROW_ID = 'rdkafka-batch'
RESULTS_PATH = 'results.csv'

config = {
  :"bootstrap.servers" => "localhost:9092",
  :"group.id" => "kafka-bench"
}

consumer = Rdkafka::Config.new(config).consumer
consumer.subscribe("kafka_bench_json")

consumer.each_slice(100) do |batch|
  # There's an each_batch method but I can't get it to
  # work...
  # https://www.rubydoc.info/github/appsignal/rdkafka-ruby/Rdkafka/Consumer#each_batch-instance_method
  # Does it make any practical difference?
  @count ||= 0
  @starting_time = Time.now if @count.zero?
  @count += batch.size
  puts @count

  next unless @count >= 100_000

  time_taken = Time.now - @starting_time
  puts "Time taken: #{time_taken}"

  CSV.open(RESULTS_PATH, 'a') do |csv|
    csv << [ROW_ID, time_taken, @count]
  end

  @count = 0
end