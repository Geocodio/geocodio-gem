# frozen_string_literal: true

require 'dotenv'
Dotenv.load

RSpec.describe Geocodio do

  api_key = ENV["API_KEY"] 
  geocodio = Geocodio::Gem.new(api_key)

  it "has a version number" do
    expect(Geocodio::VERSION).not_to be nil
  end

  it "has an API Key" do
    expect(geocodio).not_to be nil
  end

  it "geocodes a single address" do
    expect(geocodio.geocode).to eq("1109 N Highland St, Arlington, VA")
  end
end
