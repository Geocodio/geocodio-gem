# frozen_string_literal: true

require_relative "gem/version"
require "faraday"
require "byebug"

module Geocodio

  class Error < StandardError; end
    
  class Gem
    def initialize(api_key)
      @api_key = api_key
    end

    def geocode(query)
      conn = Faraday.new(
        url: 'https://api.geocod.io/v1.7/',
        headers: {'Content-Type' => 'application/json' }
      )

      response = conn.get('geocode', { q: query, api_key: @api_key }).body
      parsed = JSON.parse(response)
      return parsed
    end
  end
end
