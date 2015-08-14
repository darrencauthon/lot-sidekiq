require_relative '../../spec_helper'

describe Lot::Sidekiq::Worker do

  let(:worker) { Lot::Sidekiq::Worker.new }

  it "should be a sidekiq worker" do
    worker.is_a?(::Sidekiq::Worker).must_equal true
  end

end
