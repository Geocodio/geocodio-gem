# frozen_string_literal: true

require_relative "gem/version"
require "faraday"
require "byebug"

module Geocodio

  class Error < StandardError; end

  class Gem
    def initialize(api_key)
      @api_key = api_key

      @conn = Faraday.new(
        url: 'https://api.geocod.io/v1.7/',
        headers: {'Content-Type' => 'application/json' }
      )
    end

    def geocode(query, fields=[])

      if query.size < 1
        raise ArgumentError, 'Please provide at least one address to geocode.'
      elsif
        response = @conn.get('geocode', { q: query, fields: fields.join(","), api_key: @api_key }).body
        parsed = JSON.parse(response)
        return parsed
      end
    end

    def reverse(query, fields=[])
      if query.size < 1
        raise ArgumentError, 'Please provide at least one set of coordinates to geocode.'
      elsif
        response = @conn.get('reverse', { q: query, fields: fields.join(","), api_key: @api_key}).body
        parsed = JSON.parse(response)
        return parsed
      end
    end
  end
end
