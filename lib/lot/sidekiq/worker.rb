module Lot

  module Sidekiq

    class Worker
      include ::Sidekiq::Worker

      def perform *args
        build_the_event_subscriber(*args).execute
      end

      def build_the_event_subscriber event_subscriber, event, data, instigator
        event_subscriber.constantize.new.tap do |subscriber|
          subscriber.event = event
          subscriber.data  = HashWithIndifferentAccess.new(data || {})
          if instigator
            record_type, id = instigator.split ':'
            subscriber.instigator = Lot.class_from_record_type(record_type).find id
          end
        end
      end

    end

  end

end
