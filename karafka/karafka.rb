# frozen_string_literal: true

# This file is auto-generated during the install process.
# If by any chance you've wanted a setup for Rails app, either run the `karafka:install`
# command again or refer to the install templates available in the source codes

require_relative 'avro_deserializer'

ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']
Bundler.require(:default, ENV['KARAFKA_ENV'])

# Zeitwerk custom loader for loading the app components before the whole
# Karafka framework configuration
APP_LOADER = Zeitwerk::Loader.new
APP_LOADER.enable_reloading

%w[
  lib
  app/consumers
].each { |dir| APP_LOADER.push_dir(dir) }

APP_LOADER.setup
APP_LOADER.eager_load

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = { 'bootstrap.servers': '127.0.0.1:9092' }
    config.client_id = "karafka_json_batch_#{Time.now.to_i}"
  end
  puts "single"


  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  routes.draw do
    consumer_group :batch do
      topic :kafka_bench_avro do
        consumer BatchBenchConsumer
        deserializer AvroDeserializer.new(AvroTurf.new(schemas_path: '../avro_schema'), 'address')
      end
    end

    consumer_group :single do
      topic :kafka_bench_avro do
        consumer SingleBenchConsumer
        deserializer AvroDeserializer.new(AvroTurf.new(schemas_path: '../avro_schema'), 'address')
      end
    end
  end
end
