module Lot

  class EventSubscriber

    def self.fire event, data, instigator
      instigator = "#{instigator.record_type}:#{instigator.id}" if instigator
      Lot::Sidekiq::Worker.perform_async 'OneEventSubscriber', event, data, instigator
    end

  end

end
