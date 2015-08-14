require_relative '../../spec_helper'

describe Lot::Sidekiq::Worker do

  let(:worker) { Lot::Sidekiq::Worker.new }

  it "should be a sidekiq worker" do
    worker.is_a?(::Sidekiq::Worker).must_equal true
  end

  describe "perform" do

    let(:subscriber) { Lot::EventSubscriber.new }

    let(:the_key)   { random_string }
    let(:the_value) { random_string }

    let(:the_event_subscriber) { random_string }
    let(:the_event)            { random_string }
    let(:the_data)             { { the_key => the_value } }

    before do
      the_event_subscriber
        .stubs(:constantize)
        .returns Struct.new(:new).new(subscriber)
    end

    describe "no instigator" do

      let(:the_instigator)       { nil }

      it "should instantiate the worker with the right values and then run it" do

        subscriber.expects(:execute).with do |e, d, i|
          subscriber.event.must_equal the_event
          subscriber.data[the_key].must_equal the_value
          subscriber.instigator.nil?.must_equal true
        end

        worker.perform the_event_subscriber, the_event, the_data, the_instigator

      end

      it "should convert the hash to a case insenstiive hash" do
        subscriber.expects(:execute).with do |e, d, i|
          subscriber.data[the_key.to_sym].must_equal the_value
        end

        worker.perform the_event_subscriber, the_event, the_data, the_instigator
      end

      describe "but the data is nil" do

        let(:the_data) { nil }

        it "should still get an indifferent hash" do

          subscriber.expects(:execute).with do |e, d, i|
            subscriber.data.count.must_equal 0

            key,value = random_string, random_string
            subscriber.data[key] = value
            subscriber.data[key].must_equal value
            subscriber.data[key.to_sym].must_equal value
          end

          worker.perform the_event_subscriber, the_event, the_data, the_instigator
            
        end

      end

    end
    j
    describe "an instigator" do

      let(:the_record_type) { random_string }
      let(:the_record_id)   { random_string }
      let(:the_instigator)  { "#{the_record_type}:#{the_record_id}" }

      let(:the_real_instigator) { Object.new }

      before do
        constantized_record = Object.new
        constantized_record.stubs(:find).with(the_record_id).returns the_real_instigator
        Lot.stubs(:class_from_record_type).with(the_record_type).returns constantized_record
      end

      it "should instantiate the worker with the instgator" do

        subscriber.expects(:execute).with do |e, d, i|
          subscriber.instigator.must_be_same_as the_real_instigator
        end

        worker.perform the_event_subscriber, the_event, the_data, the_instigator

      end

      it "should convert the hash to a case insenstiive hash" do
        subscriber.expects(:execute).with do |e, d, i|
          subscriber.data[the_key.to_sym].must_equal the_value
        end

        worker.perform the_event_subscriber, the_event, the_data, the_instigator
      end

    end

  end

end
