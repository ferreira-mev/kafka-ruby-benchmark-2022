**(WIP)**

This fork of [this repo](https://github.com/imanel/kafka-ruby-benchmark) contains the code for a simple benchmark test comparing the consuming of messages in the `karafka` and `rdkafka-ruby` gems.

# Environment setup

I thought it would have been better to run these tests on a container, but I had some trouble setting up Kafka on Docker so that the endpoint was reachable from the host (yes, I did read some guides and fiddle with a number of settings). I figured it wasn't worth wasting too much time before even getting started, so I resorted to running Kafka locally as I had been doing before, by using

`zookeeper-server-start.sh config/zookeeper.properties`

`kafka-server-start.sh config/server.properties`

(which will, of course, require having Kafka installed (I have version 3.3.1) and having its `bin` directory on your `$PATH`).

# Running the tests

## Karafka

To run the Karafka tests, `cd` into `karafka` and run

`bundle exec karafka server --consumer_groups batch`

or

`bundle exec karafka server --consumer_groups single`,

as desired.

## rdkafka

The `rdkafka` tests can be run simply as regular Ruby programs, by executing

`ruby rdkafka/single.rb`

or

`ruby rdkafka/batch.rb`.

Note that there is no set number of messages to receive until the consumets are stopped, so they will carry on polling until manually stopped.