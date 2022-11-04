# frozen_string_literal: true

require 'csv'

# Consumer used to consume benchmark messages
class BenchConsumer < ApplicationConsumer
  def row_id
    'karafka-single'
  end

  def results_path
    '../../results.csv'
  end

  def consume_one
    @@count ||= 0
    @@starting_time = Time.now if @@count.zero?
    @@count += 1

    puts @@count

    if @@count >= 100_000
      time_taken = Time.now - @@starting_time

      puts "#{row_id} read #{@@count} messages in #{time_taken}"

      CSV.open(results_path, 'a') do |csv|
        csv << [row_id, time_taken, @@count]
      end

      @@count = 0
    end
  end

  # Run anything upon partition being revoked
  # def revoked
  # end

  # Define here any teardown things you want when Karafka server stops
  # def shutdown
  # end
end
