require 'sinatra/base'

# @module Sinatra
module Sinatra
  # @module ApplicationHelper
  module ApplicationHelper
    def simbolize_keys(hash)
      hash.tap do |h|
        h.keys.each { |k| h[k.to_sym] = h.delete(k) }
      end
    end
  end
  helpers ApplicationHelper
end
