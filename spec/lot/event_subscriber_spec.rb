require_relative '../spec_helper'

class OneEventSubscriber < Lot::EventSubscriber
end

describe Lot::EventSubscriber do

  describe "fire" do

    let(:the_event) { Object.new }
    let(:the_data)  { Object.new }

    describe "without an instigator" do

      let(:the_instigator) { nil }

      it "should call perform_async with the relevant data" do
        Lot::Sidekiq::Worker.expects(:perform_async).with 'OneEventSubscriber', the_event, the_data, nil
        OneEventSubscriber.fire the_event, the_data, the_instigator
      end

    end

    describe "with an instigator" do

      let(:the_record_type) { random_string }
      let(:the_id)          { random_string }
      let(:the_instigator)  { Struct.new(:record_type, :id).new the_record_type, the_id }

      it "should call perform_async with the relevant data" do
        Lot::Sidekiq::Worker.expects(:perform_async).with 'OneEventSubscriber', the_event, the_data, "#{the_record_type}:#{the_id}"
        OneEventSubscriber.fire the_event, the_data, the_instigator
      end

    end

  end

end
