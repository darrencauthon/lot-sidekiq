module Lot

  module Sidekiq

    class Worker
      include ::Sidekiq::Worker

      def perform event_subscriber, event, data, instigator
        event_subscriber.constantize.new.tap do |subscriber|
          subscriber.event = event
          subscriber.data = data
          subscriber.execute
        end
      end

    end

  end

end
