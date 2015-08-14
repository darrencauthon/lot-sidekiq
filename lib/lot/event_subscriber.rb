module Lot

  class EventSubscriber

    def self.fire event, data, instigator
      Lot::Sidekiq::Worker.perform_async 'OneEventSubscriber', event, data, nil
    end

  end

end
