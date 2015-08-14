require_relative '../lib/lot/sidekiq'
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'

def random_string
  SecureRandom.uuid
end
