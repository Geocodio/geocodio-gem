require_relative "gem/version"
require "faraday"
require "faraday/follow_redirects"
require "csv"
require "uri"

module Geocodio

  class Error < StandardError; end

  class Gem
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key

      @conn = Faraday.new(
        url: 'https://api.geocod.io/v1.10/',
        headers: {'Content-Type' => 'application/json' }
      ) do |f|
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
      end
    end

    # Forward geocode addresses to coordinates
    # @param query [Array] Array of address strings
    # @param fields [Array] Optional fields to append (e.g., ["timezone", "cd"])
    # @param limit [Integer] Maximum number of results
    # @param format [String] Response format ("simple" for simplified response)
    # @param destinations [Array] Optional array of destination coordinates for distance calculation
    # @param distance_mode [Symbol] Distance mode (:straightline, :driving, :haversine)
    # @param distance_units [Symbol] Distance units (:miles, :kilometers)
    # @param distance_options [Hash] Additional distance options (max_results, max_distance, etc.)
    def geocode(query=[], fields=[], limit=nil, format=nil,
                destinations: nil, distance_mode: nil, distance_units: nil, distance_options: nil)
      if query.size < 1
        raise ArgumentError, 'Please provide at least one address to geocode.'
      elsif query.size == 1
        # Build query string manually to handle array parameters correctly
        query_parts = [
          "api_key=#{@api_key}",
          "q=#{URI.encode_www_form_component(query.join(""))}"
        ]
        query_parts << "fields=#{URI.encode_www_form_component(fields.join(","))}" if fields && !fields.empty?
        query_parts << "limit=#{limit}" if limit
        query_parts << "format=#{format}" if format

        # Add distance parameters if destinations provided
        distance_parts = build_geocode_distance_query_parts(destinations, distance_mode, distance_units, distance_options)
        query_parts.concat(distance_parts)

        response = JSON.parse(@conn.get("geocode?#{query_parts.join('&')}").body)
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

    # Reverse geocode coordinates to addresses
    # @param query [Array] Array of coordinate strings ("lat,lng")
    # @param fields [Array] Optional fields to append (e.g., ["timezone", "cd"])
    # @param limit [Integer] Maximum number of results
    # @param format [String] Response format ("simple" for simplified response)
    # @param destinations [Array] Optional array of destination coordinates for distance calculation
    # @param distance_mode [Symbol] Distance mode (:straightline, :driving, :haversine)
    # @param distance_units [Symbol] Distance units (:miles, :kilometers)
    # @param distance_options [Hash] Additional distance options (max_results, max_distance, etc.)
    def reverse(query=[], fields=[], limit=nil, format=nil,
                destinations: nil, distance_mode: nil, distance_units: nil, distance_options: nil)
      if query.size < 1
        raise ArgumentError, 'Please provide at least one set of coordinates to geocode.'
      elsif query.size == 1
        # Build query string manually to handle array parameters correctly
        query_parts = [
          "api_key=#{@api_key}",
          "q=#{URI.encode_www_form_component(query.join(""))}"
        ]
        query_parts << "fields=#{URI.encode_www_form_component(fields.join(","))}" if fields && !fields.empty?
        query_parts << "limit=#{limit}" if limit
        query_parts << "format=#{format}" if format

        # Add distance parameters if destinations provided
        distance_parts = build_geocode_distance_query_parts(destinations, distance_mode, distance_units, distance_options)
        query_parts.concat(distance_parts)

        response = JSON.parse(@conn.get("reverse?#{query_parts.join('&')}").body)
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

    # Distance API Methods

    # Calculate distances from a single origin to multiple destinations
    # @param origin [String, Array, Hash] Origin coordinate ("lat,lng" or "lat,lng,id" or [lat, lng] or [lat, lng, id] or {lat:, lng:, id:})
    # @param destinations [Array] Array of destination coordinates in any supported format
    # @param options [Hash] Optional parameters:
    #   - mode: :straightline (default), :driving, or :haversine (alias for straightline)
    #   - units: :miles (default) or :kilometers
    #   - max_results: Integer, limit number of results
    #   - max_distance: Float, filter by max distance
    #   - max_duration: Integer, filter by max duration (seconds, driving only)
    #   - min_distance: Float, filter by min distance
    #   - min_duration: Integer, filter by min duration (seconds, driving only)
    #   - order_by: :distance (default) or :duration
    #   - sort: :asc (default) or :desc
    def distance(origin, destinations, options = {})
      raise ArgumentError, 'Please provide an origin coordinate.' if origin.nil?
      raise ArgumentError, 'Please provide at least one destination.' if destinations.nil? || destinations.empty?

      # Build query string manually to handle array parameters correctly
      query_parts = [
        "api_key=#{@api_key}",
        "origin=#{URI.encode_www_form_component(format_coordinate_string(origin))}"
      ]

      # Add destinations as properly formatted array parameters
      destinations.each do |dest|
        query_parts << "destinations[]=#{URI.encode_www_form_component(format_coordinate_string(dest))}"
      end

      # Add distance options
      build_distance_params(options).each do |key, value|
        query_parts << "#{key}=#{URI.encode_www_form_component(value.to_s)}"
      end

      response = JSON.parse(@conn.get("distance?#{query_parts.join('&')}").body)
      return response
    end

    # Calculate distance matrix from multiple origins to multiple destinations
    # @param origins [Array] Array of origin coordinates
    # @param destinations [Array] Array of destination coordinates
    # @param options [Hash] Same options as distance() method
    def distanceMatrix(origins, destinations, options = {})
      raise ArgumentError, 'Please provide at least one origin.' if origins.nil? || origins.empty?
      raise ArgumentError, 'Please provide at least one destination.' if destinations.nil? || destinations.empty?

      body = {
        origins: origins.map { |coord| format_coordinate_object(coord) },
        destinations: destinations.map { |coord| format_coordinate_object(coord) }
      }

      # Add distance options to body
      body.merge!(build_distance_body_params(options))

      response = @conn.post('distance-matrix') do |req|
        req.params = { api_key: @api_key }
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
      end

      parsed = JSON.parse(response.body)
      return parsed
    end

    # Create an async distance matrix job
    # @param name [String] Job name
    # @param origins [Array, Integer] Array of coordinates or list ID
    # @param destinations [Array, Integer] Array of coordinates or list ID
    # @param options [Hash] Same options as distanceMatrix() plus:
    #   - callback_url: URL for webhook notification
    def createDistanceMatrixJob(name, origins, destinations, options = {})
      raise ArgumentError, 'Please provide a job name.' if name.nil? || name.empty?
      raise ArgumentError, 'Please provide origins.' if origins.nil?
      raise ArgumentError, 'Please provide destinations.' if destinations.nil?

      body = { name: name }

      # Origins can be array of coordinates or list ID (integer)
      if origins.is_a?(Integer)
        body[:origins] = origins
      else
        body[:origins] = origins.map { |coord| format_coordinate_object(coord) }
      end

      # Destinations can be array of coordinates or list ID (integer)
      if destinations.is_a?(Integer)
        body[:destinations] = destinations
      else
        body[:destinations] = destinations.map { |coord| format_coordinate_object(coord) }
      end

      # Add distance options
      body.merge!(build_distance_body_params(options))

      # Add callback URL if provided
      body[:callback_url] = options[:callback_url] if options[:callback_url]

      response = @conn.post('distance-jobs') do |req|
        req.params = { api_key: @api_key }
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
      end

      parsed = JSON.parse(response.body)
      return parsed
    end

    # Get status of a distance matrix job
    # @param id [String, Integer] Job ID
    def distanceMatrixJobStatus(id)
      response = JSON.parse(@conn.get("distance-jobs/#{id}", { api_key: @api_key }).body)
      return response
    end

    # List all distance matrix jobs
    # @param page [Integer] Optional page number for pagination
    def distanceMatrixJobs(page = nil)
      params = { api_key: @api_key }
      params[:page] = page if page
      response = JSON.parse(@conn.get("distance-jobs", params).body)
      return response
    end

    # Get results of a completed distance matrix job
    # @param id [String, Integer] Job ID
    def getDistanceMatrixJobResults(id)
      response = JSON.parse(@conn.get("distance-jobs/#{id}/download", { api_key: @api_key }).body)
      return response
    end

    # Download distance matrix job results to a file
    # @param id [String, Integer] Job ID
    # @param file_path [String] Path to save the file
    def downloadDistanceMatrixJob(id, file_path)
      response = @conn.get("distance-jobs/#{id}/download", { api_key: @api_key })
      File.write(file_path, response.body)
      return { success: true, file_path: file_path }
    end

    # Delete a distance matrix job
    # @param id [String, Integer] Job ID
    def deleteDistanceMatrixJob(id)
      response = JSON.parse(@conn.delete("distance-jobs/#{id}", { api_key: @api_key }).body)
      return response
    end

    private

    # Format a coordinate for GET requests (string format: "lat,lng" or "lat,lng,id")
    def format_coordinate_string(coord)
      case coord
      when String
        coord
      when Array
        if coord.length >= 3
          "#{coord[0]},#{coord[1]},#{coord[2]}"
        else
          "#{coord[0]},#{coord[1]}"
        end
      when Hash
        str = "#{coord[:lat]},#{coord[:lng]}"
        str += ",#{coord[:id]}" if coord[:id]
        str
      else
        raise ArgumentError, "Invalid coordinate format: #{coord.inspect}"
      end
    end

    # Format a coordinate for POST requests (object format: {lat:, lng:, id:})
    def format_coordinate_object(coord)
      case coord
      when String
        parts = coord.split(',').map(&:strip)
        obj = { lat: parts[0].to_f, lng: parts[1].to_f }
        obj[:id] = parts[2] if parts[2]
        obj
      when Array
        obj = { lat: coord[0].to_f, lng: coord[1].to_f }
        obj[:id] = coord[2].to_s if coord[2]
        obj
      when Hash
        obj = { lat: coord[:lat].to_f, lng: coord[:lng].to_f }
        obj[:id] = coord[:id].to_s if coord[:id]
        obj
      else
        raise ArgumentError, "Invalid coordinate format: #{coord.inspect}"
      end
    end

    # Build distance query parameters for GET requests
    def build_distance_params(options)
      params = {}

      # Mode (map haversine to straightline)
      if options[:mode]
        mode = options[:mode].to_s
        mode = 'straightline' if mode == 'haversine'
        params[:mode] = mode
      end

      # Units (map kilometers to km for API compatibility)
      if options[:units]
        units = options[:units].to_s
        units = 'km' if units == 'kilometers'
        params[:units] = units
      end

      params[:max_results] = options[:max_results] if options[:max_results]
      params[:max_distance] = options[:max_distance] if options[:max_distance]
      params[:max_duration] = options[:max_duration] if options[:max_duration]
      params[:min_distance] = options[:min_distance] if options[:min_distance]
      params[:min_duration] = options[:min_duration] if options[:min_duration]
      params[:order_by] = options[:order_by].to_s if options[:order_by]
      params[:sort] = options[:sort].to_s if options[:sort]

      params
    end

    # Build distance body parameters for POST requests
    def build_distance_body_params(options)
      params = {}

      # Mode (map haversine to straightline)
      if options[:mode]
        mode = options[:mode].to_s
        mode = 'straightline' if mode == 'haversine'
        params[:mode] = mode
      end

      # Units (map kilometers to km for API compatibility)
      if options[:units]
        units = options[:units].to_s
        units = 'km' if units == 'kilometers'
        params[:units] = units
      end

      params[:max_results] = options[:max_results] if options[:max_results]
      params[:max_distance] = options[:max_distance] if options[:max_distance]
      params[:max_duration] = options[:max_duration] if options[:max_duration]
      params[:min_distance] = options[:min_distance] if options[:min_distance]
      params[:min_duration] = options[:min_duration] if options[:min_duration]
      params[:order_by] = options[:order_by].to_s if options[:order_by]
      params[:sort] = options[:sort].to_s if options[:sort]

      params
    end

    # Build distance query string parts for geocode/reverse requests
    # Returns an array of query string parts to be joined with '&'
    def build_geocode_distance_query_parts(destinations, distance_mode, distance_units, distance_options)
      parts = []

      return parts unless destinations && !destinations.empty?

      # Add destinations as properly formatted array parameters
      destinations.each do |dest|
        parts << "destinations[]=#{URI.encode_www_form_component(format_coordinate_string(dest))}"
      end

      # Mode (map haversine to straightline)
      if distance_mode
        mode = distance_mode.to_s
        mode = 'straightline' if mode == 'haversine'
        parts << "distance_mode=#{mode}"
      end

      # Units (map kilometers to km)
      if distance_units
        units = distance_units.to_s
        units = 'km' if units == 'kilometers'
        parts << "distance_units=#{units}"
      end

      # Additional options
      if distance_options
        parts << "distance_max_results=#{distance_options[:max_results]}" if distance_options[:max_results]
        parts << "distance_max_distance=#{distance_options[:max_distance]}" if distance_options[:max_distance]
        parts << "distance_max_duration=#{distance_options[:max_duration]}" if distance_options[:max_duration]
        parts << "distance_min_distance=#{distance_options[:min_distance]}" if distance_options[:min_distance]
        parts << "distance_min_duration=#{distance_options[:min_duration]}" if distance_options[:min_duration]
        parts << "distance_order_by=#{distance_options[:order_by]}" if distance_options[:order_by]
        parts << "distance_sort=#{distance_options[:sort]}" if distance_options[:sort]
      end

      parts
    end
  end
end

#TODO: Look into filter_sensitive_data
#Add sample_list_test.csv to repo
