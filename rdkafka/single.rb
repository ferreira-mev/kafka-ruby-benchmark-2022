# frozen_string_literal: true

require 'rdkafka'
require 'csv'
require 'avro_turf'

require_relative 'base_consumer'

class SingleBenchConsumer < BaseConsumer
  def row_id
    'rdkafka-single'
  end

  def schema
    'address'
  end

  def poll
    @consumer.each do |message|
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

SingleBenchConsumer.new.poll
