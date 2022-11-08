# frozen_string_literal: true

# frozen_string_literal: true

require 'rdkafka'
require 'csv'
require 'avro_turf'

require_relative 'base_consumer'

class BatchBenchConsumer < BaseConsumer
  def row_id
    'rdkafka-single'
  end

  def schema
    'address'
  end

  def initialize(topic = 'kafka_bench_avro', group_id = 'kafka-bench', batch_size = 100)
    super(topic, group_id)
    @batch_size = 100
  end

  def poll
    @consumer.each_slice(@batch_size) do |batch|
      # There's an each_batch method but I can't get it to
      # work...
      # https://www.rubydoc.info/github/appsignal/rdkafka-ruby/Rdkafka/Consumer#each_batch-instance_method
      # Does it make any practical difference?

      batch.each do |message|
        @count ||= 0
        @starting_time = Time.now if @count.zero?
        @count += 1

        avro.decode(message.payload, schema_name: schema)

        next unless @count >= 100_000

        time_taken = Time.now - @starting_time

        puts "#{row_id} read #{@count} messages in #{time_taken}"

        CSV.open(results_path, 'a') do |csv|
          csv << [row_id, time_taken, @count]
        end

        @count = 0
      end
    end
  end
end

BatchBenchConsumer.new.poll
