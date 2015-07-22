ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start

require 'rack/test'
require 'sinatra'
require './app.rb'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
