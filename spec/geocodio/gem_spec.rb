# frozen_string_literal: true

RSpec.describe Geocodio do

  geocodio = Geocodio::Gem.new("API_KEY")

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
