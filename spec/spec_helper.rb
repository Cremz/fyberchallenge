ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
end
require 'rack/test'
require 'sinatra'
require_relative '../helpers/application_helper'
require './app.rb'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
