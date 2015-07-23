require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'
require 'sinatra/config_file'
require 'em/pure_ruby'
require './helpers/application_helper'
require 'digest'

# require the app directory
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each { |file| require file }

# @class FiberChallenge
class FyberChallenge < Sinatra::Base
  register Sinatra::ConfigFile
  register Sinatra::Reloader
  # helpers
  helpers Sinatra::JSON
  helpers Sinatra::ApplicationHelper

  config_file './config.yml'

  def generate_query_string(hash)
    hash.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')
  end

  def http_response(url)
    uri  = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new uri.request_uri
    http.request(request).body
  end

  get '/' do
    erb :index
  end

  post '/generate' do
    if params.empty?
      return json success: false, error: 'No parameters were sent'
    end

    if params.map { |_k, value| value.empty? }.any?
      return json success: false, error: 'Please fill all the required values'
    end
    query_string = generate_query_string({
      appid:        settings.appid,
      format:       settings.format,
      device_id:    settings.device_id,
      locale:       settings.locale,
      ip:           settings.ip,
      offer_types:  settings.offer_types,
      timestamp:    Time.now.getutc.to_i
    }.merge(simbolize_keys(params)))

    hashkey = Digest::SHA1.hexdigest "#{query_string}&#{settings.api_key}"

    response_body = http_response "http://api.sponsorpay.com/feed/v1/offers.json?#{query_string}&hashkey=#{hashkey}"

    content_type :json
    response_body
  end
end
