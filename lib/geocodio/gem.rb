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

    def geocode
      response = Faraday.get("https://api.geocod.io/v1.7/geocode?q=1109+N+Highland+St%2c+Arlington+VA&api_key=TEST_API_KEY")
      parsed = JSON.parse(response.body)
      return parsed["input"]["formatted_address"]
    end
  end
end
