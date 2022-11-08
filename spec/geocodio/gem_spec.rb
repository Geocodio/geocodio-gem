# frozen_string_literal: true

require 'dotenv'
Dotenv.load

RSpec.describe Geocodio do

  api_key = ENV["API_KEY"]
  address_sample = "1109 N Highland St, Arlington, VA 22201"
  coords_sample = "38.9002898,-76.9990361"
  appended_fields = "school" 
  geocodio = Geocodio::Gem.new(api_key)

  it "has a version number" do
    expect(Geocodio::VERSION).not_to be nil
  end

  it "has an API Key" do
    expect(geocodio).not_to be nil
  end

  it "geocodes a single address" do
    expect(geocodio.geocode(address_sample)["results"][0]["formatted_address"]).to eq(address_sample)
  end

  it "appends fields to single address" do
    expect(geocodio.geocode(address_sample, appended_fields)["results"][0]["fields"]["school_districts"]["unified"]["name"]).to eq("Arlington County Public Schools")
  end

  it "reverse geocodes coordinates" do
    expect(geocodio.reverse(coords_sample)["results"][0]["location"]).to eq({"lat"=>38.900432, "lng"=>-76.999031})
  end
end
