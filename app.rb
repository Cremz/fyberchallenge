require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'sinatra/reloader'
require 'json'
require 'sinatra/config_file'
require 'em/pure_ruby'

# require the app directory
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each { |file| require file }

# @class FiberChallenge
class FyberChallenge < Sinatra::Base
  get '/' do
    erb :index
  end
end
