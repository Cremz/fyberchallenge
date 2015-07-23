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
  register Sinatra::ConfigFile

config_file './config.yml'

  get '/' do
    erb :index
  end

  post '/generate' do
    puts settings
    build_params = {
      appid:        settings.appid,
      format:       settings.format,
      device_id:    settings.device_id,
      locale:       settings.locale,
      ip:           settings.ip,
      offer_types:  settings.offer_types,
      api_key:      settings.api_key
    }.merge(params)
    content_type :json
    build_params.to_json
  end
end
