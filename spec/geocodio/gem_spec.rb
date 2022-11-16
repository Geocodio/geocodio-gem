# frozen_string_literal: true

require 'dotenv'
require 'pathname'
Dotenv.load

RSpec.describe Geocodio do

  ## CONFIG
  api_key = ENV["API_KEY"]
  geocodio = Geocodio::Gem.new(api_key)

  ## SINGLE DATA SAMPLES
  address_sample = ["1109 N Highland St, Arlington, VA 22201"]
  coords_sample = ["38.9002898,-76.9990361"]
  appended_fields = ["school", "cd"]
  
  ## BATCH DATA SAMPLES
  batch_addresses = [
    "1109 N Highland St, Arlington, VA 22201",
    "12187 Darnestown Rd, Gaithersburg, MD 20878",
    "4961 Elm Street, Bethesda, MD" 
  ]
  batch_coordinates = [
    "38.88674717512318, -77.09464642536076",
    "39.118308110111954, -77.2516753863881",
    "38.98237295882022, -77.09805507289941"
  ]  

  ## LISTS DATA
  file = "sample_list_test.csv"
  path = File.read(file)
  filename = "sample_list_test.csv" 
  format = "{{A}} {{B}} {{C}} {{D}}"

  it "has a version number" do
    expect(Geocodio::VERSION).not_to be nil
  end

  it "has an API Key" do
    expect(geocodio).not_to be nil
  end

  it "geocodes a single address" do
    expect(geocodio.geocode(address_sample)["results"][0]["formatted_address"]).to eq(address_sample.join(""))
  end

  it "appends fields to single address" do
    expect(geocodio.geocode(address_sample, appended_fields)["results"][0]["fields"]["school_districts"]["unified"]["name"]).to eq("Arlington County Public Schools")
  end

  it "reverse geocodes coordinates" do
    expect(geocodio.reverse(coords_sample)["results"][0]["location"]).to eq({"lat"=>38.900432, "lng"=>-76.999031})
  end

  it "appends fields to coordinates" do
    expect(geocodio.reverse(coords_sample, appended_fields)["results"][0]["fields"]["school_districts"]["unified"]["name"]).to eq("District of Columbia Public Schools")
  end

  it "batch geocodes multiple addresses" do
    expect(geocodio.geocode(batch_addresses)["results"].size).to equal(batch_addresses.size)
  end

  it "reverse geocodes batch coordinates" do
    expect(geocodio.reverse(batch_coordinates)["results"].size).to equal(batch_coordinates.size)
  end

  it "creates list from file" do
    expect(geocodio.createList(path, filename, "forward", format)["file"]["filename"]).to eq(filename)
  end

  it "gets list using ID" do
    expect(geocodio.getList(11533825)["id"]).to be(11533825)
  end

  it "gets all lists" do
    expect(geocodio.getAllLists).to_not be(nil)
  end
end
