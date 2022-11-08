# frozen_string_literal: true

# See https://karafka.io/docs/Deserialization/
class AvroDeserializer
  attr_reader :avro, :schema

  def initialize(avro, schema)
    @avro = avro
    @schema = schema
  end

  def call(message)
    avro.decode(message.raw_payload, schema_name: schema)
  end
end
