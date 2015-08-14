module Lot

  module Sidekiq

    class Worker
      include ::Sidekiq::Worker

      def perform event_subscriber, event, data, instigator
        event_subscriber.constantize.new.tap do |subscriber|

          if instigator
            subscriber.instigator = instigator.split(':')[0].constantize.find instigator.split(':')[1]
          end

          subscriber.event = event
          subscriber.data = HashWithIndifferentAccess.new(data || {})
          subscriber.execute
        end
      end

    end

  end

end
