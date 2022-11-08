# frozen_string_literal: true

require 'rdkafka'

class BaseConsumer
  def results_path
    'results.csv'
    # Presuming benchmarks would be executed from the project root
  end

  def initialize(topic = 'kafka_bench_avro', group_id = 'kafka-bench')
    @config = {
      :"bootstrap.servers" => 'localhost:9092',
      :"group.id" => group_id,
      :"auto.offset.reset" => 'earliest'
    }

    @consumer = Rdkafka::Config.new(@config).consumer
    @consumer.subscribe(topic)
  end

  def avro
    AvroTurf.new(schemas_path: 'avro_schema')
  end
end
