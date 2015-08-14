module Lot

  module Sidekiq

    class Worker
      include ::Sidekiq::Worker

      def perform event_subscriber, event, data, instigator
        event_subscriber.constantize.new.tap do |subscriber|

          if instigator
            subscriber.instigator = Lot.class_from_record_type(instigator.split(':')[0]).find instigator.split(':')[1]
          end

          subscriber.event = event
          subscriber.data = HashWithIndifferentAccess.new(data || {})
          subscriber.execute
        end
      end

    end

  end

end
