# frozen_string_literal: true

require_relative "gem/version"
require "faraday"

module Geocodio

  class Error < StandardError; end
    
  class Gem 
    def initialize(api_key)
      @api_key = api_key
    end
  end
end
