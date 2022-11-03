# frozen_string_literal: true

RSpec.describe Geocodio do

  it "has a version number" do
    expect(Geocodio::VERSION).not_to be nil
  end

  it "has an API Key" do
    expect(Geocodio::Gem.new("API_KEY")).not_to be nil
  end
end
