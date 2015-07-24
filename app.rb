require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'
require 'sinatra/config_file'
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
  # Config file for the api connect settings. For the purpose of this challenge I decided to keep them in a file.
  # They can be stored in env variables or even passed in a form if we want a more complex page.
  config_file './config.yml'

  # Return the first part of the query string, the one needed to generate the hash.
  def generate_query_string(hash)
    hash.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')
  end

  # Receives a url string and returns the response body
  def http_response(url)
    uri  = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new uri.request_uri
    http.request(request).body
  end

  # TODO: Refactor to look nicer. This is used to output alert messages in bootstrap depending on the type of alert sent.
  def message(type, text)
    "<div class=\"alert alert-#{type} alert-dismissible\" role=\"alert\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><strong>#{text}</div>"
  end

  # Default path
  get '/' do
    erb :index
  end

  # This is where the magic happens. The requests are sent from the form to this route, the api url is generated and the response from the api is sent to the js template
  post '/generate' do
    # Simple check if no params are sent. Can't be accessed from the browser, but it's good to have it for safety.
    if params.empty?
      return json success: false, error: 'No parameters were sent'
    end

    # Check to see if the required uid parameter is sent
    if params[:uid].nil? || params[:uid].empty?
      content_type 'text/javascript'
      return erb :no_uid, layout: false
    end

    # Generate the query string using the settings and the params sent from the browser
    query_string = generate_query_string({
      appid:        settings.appid,
      format:       settings.format,
      device_id:    settings.device_id,
      locale:       settings.locale,
      ip:           settings.ip,
      offer_types:  settings.offer_types,
      timestamp:    Time.now.getutc.to_i
    }.merge(simbolize_keys(params)))

    # Generate the hashkey needed for the api call
    hashkey = Digest::SHA1.hexdigest "#{query_string}&#{settings.api_key}"

    # Parse the http response from the api url. Returns a hash used in the js template
    @response_body = JSON.parse(http_response("http://api.sponsorpay.com/feed/v1/offers.json?#{query_string}&hashkey=#{hashkey}"))

    content_type 'text/javascript'
    return erb :results, layout: false
  end
end
