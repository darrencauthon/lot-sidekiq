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

    end

  end

end
