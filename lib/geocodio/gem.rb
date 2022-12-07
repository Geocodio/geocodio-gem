require_relative "gem/version"
require "faraday"
require "faraday/follow_redirects"
require "csv"
require "byebug"

module Geocodio

  class Error < StandardError; end

  class Gem
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key

      @conn = Faraday.new(
        url: 'https://api.geocod.io/v1.7/',
        headers: {'Content-Type' => 'application/json' }
      ) do |f|
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
      end
    end

    def geocode(query=[], fields=[], limit=nil, format=nil)
      if query.size < 1
        raise ArgumentError, 'Please provide at least one address to geocode.'
      elsif query.size == 1 
        response = JSON.parse(@conn.get('geocode', { q: query.join(""), fields: fields.join(","), limit: limit, format: format, api_key: @api_key }).body)
        return response
      elsif query.size > 1
        response = @conn.post('geocode') do |req|
          req.params = { fields: fields.join(","), limit: limit, api_key: @api_key }
          req.headers['Content-Type'] = 'application/json'
          req.body = query.to_json
        end
        parsed = JSON.parse(response.body)
        return parsed
      end
    end

    def reverse(query=[], fields=[], limit=nil, format=nil)
      if query.size < 1
        raise ArgumentError, 'Please provide at least one set of coordinates to geocode.'
      elsif query.size == 1
        response = JSON.parse(@conn.get('reverse', { q: query.join(""), fields: fields.join(","), limit: limit, format: format, api_key: @api_key}).body)
        return response
      elsif query.size > 1
        response = @conn.post('reverse') do |req|
          req.params = { fields: fields.join(","), limit: limit, api_key: @api_key }
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
      parsed = JSON.parse(response.body)
      return parsed
    end

    def getList(id)
      response = JSON.parse(@conn.get("lists/#{id}", { api_key: @api_key }).body)
      return response
    end

    def getAllLists
      response = JSON.parse(@conn.get("lists", { api_key: @api_key}).body)
      return response
    end

    def downloadList(id)
      response = @conn.get("lists/#{id}/download", { api_key: @api_key})

      if (response.headers["content-type"] == "application/json")
        return JSON.parse(response.body)
      else
        return CSV.parse(response.body.force_encoding("UTF-8"))
      end
    end

    def deleteList(id)
      response = JSON.parse(@conn.delete("lists/#{id}", { api_key: @api_key}).body)
      return response
    end
  end
end

## Make a single batch request versus comparing query size?
## Batch requests require a little bit more digging down to get data

## Writing tests for failure states or errors
## Is there a way to get Faraday to test error states?
## Documentation with code samples - update right side of Docs
