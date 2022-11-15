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

    def geocode(query=[], fields=[])
      if query.size < 1
        raise ArgumentError, 'Please provide at least one address to geocode.'
      elsif query.size == 1 
        response = @conn.get('geocode', { q: query.join(""), fields: fields.join(","), api_key: @api_key }).body
        parsed = JSON.parse(response)
        return parsed
      elsif query.size > 1
        response = @conn.post('geocode') do |req|
          req.params = { fields: fields.join(","), api_key: @api_key }
          req.headers['Content-Type'] = 'application/json'
          req.body = query.to_json
        end
        parsed = JSON.parse(response.body)
        return parsed
      end
    end

    def reverse(query=[], fields=[])
      if query.size < 1
        raise ArgumentError, 'Please provide at least one set of coordinates to geocode.'
      elsif query.size == 1
        response = @conn.get('reverse', { q: query.join(""), fields: fields.join(","), api_key: @api_key}).body
        parsed = JSON.parse(response)
        return parsed
      elsif query.size > 1
        response = @conn.post('reverse') do |req|
          req.params = { fields: fields.join(","), api_key: @api_key }
          req.headers['Content-Type'] = 'application/json'
          req.body = query.to_json
        end
        parsed = JSON.parse(response.body)
        return parsed
      end
    end

    def createList(file, filename, direction, format, callback = nil)
      response = @conn.post('lists') do |req|
        req.params = { 
          api_key: @api_key,
          file: file,
          filename: filename,
          direction: direction,
          format: format,
          callback: callback
        }
        req.headers['Content-Type'] = 'application/json'
      end
      puts response
    end

    def getList(id)
      response = @conn.get("lists/#{id}", { api_key: @api_key }).body
      parsed = JSON.parse(response)
      return parsed
    end

    def getAllLists
      response = @conn.get("lists", { api_key: @api_key}).body
      parsed = JSON.parse(response)
      byebug
      return parsed
    end

  end
end

## Make a single batch request versus comparing query size?
## Batch requests require a little bit more digging down to get data
