# frozen_string_literal: true

require 'dotenv'
Dotenv.load

RSpec.describe Geocodio do

  api_key = ENV["API_KEY"]
  address_sample = "1661 York Ave, New York, NY" 
  geocodio = Geocodio::Gem.new(api_key)

  it "has a version number" do
    expect(Geocodio::VERSION).not_to be nil
  end

  it "has an API Key" do
    expect(geocodio).not_to be nil
  end

  it "geocodes a single address" do
    expect(geocodio.geocode(address_sample)["input"]["formatted_address"]).to eq(address_sample)
  end
end
