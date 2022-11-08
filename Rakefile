# frozen_string_literal: true

%w[
  avro_turf
  json
  kafka
  multi_json
].each(&method(:require))

ENV['KAFKA_HOST'] ||= '127.0.0.1:9092'

namespace :bench do
  desc 'Fill kafka with data for benchmark'
  task :fill_kafka do
    puts 'Inserting 1M records in batches of 1000, it might take some time'

    avro = AvroTurf.new(schemas_path: File.join(__dir__, 'avro_schema'))

    message = { 'street' => '1st st.', 'city' => 'Citytown' }
    message_avro = avro.encode(message, schema_name: 'address')

    kafka = Kafka.new seed_brokers: [ENV['KAFKA_HOST']], client_id: 'my_producer'
    producer = kafka.producer
    1_000.times do # Save 1M in batch of 1000 (limit for Kafka)
      1_000.times do
        producer.produce(message_avro, topic: 'kafka_bench_avro')
      end
      producer.deliver_messages
    end
  end
end
