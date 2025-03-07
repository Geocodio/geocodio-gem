# frozen_string_literal: true

require 'dotenv'
require 'pathname'
require 'spec_helper'
Dotenv.load

RSpec.describe Geocodio do

  ## CONFIG
  api_key = ENV["API_KEY"]
  geocodio = Geocodio::Gem.new(api_key)

  it "has a version number" do
    expect(Geocodio::VERSION).not_to be nil
  end

  it "has an API Key" do
    expect(geocodio.api_key).to be(api_key)
  end

  it "geocodes a single address", vcr: { record: :new_episodes } do
    address_sample = ["1109 N Highland St, Arlington, VA 22201"]

    expect(geocodio.geocode(address_sample)["input"]["formatted_address"]).to eq(address_sample.join(""))
    expect(geocodio.geocode(address_sample)["results"][0]["formatted_address"]).to eq(address_sample.join(""))
    expect(geocodio.geocode(address_sample)["results"][0]["address_components"]["number"]).to eq("1109")
    expect(geocodio.geocode(address_sample)["results"][0]["address_components"]["city"]).to eq("Arlington")
  end

  it "appends fields to single address", vcr: { record: :new_episodes } do
    address_sample = ["1109 N Highland St, Arlington, VA 22201"]
    appended_fields = ["school", "cd"]

    expect(geocodio.geocode(address_sample, appended_fields)["results"][0]["fields"]["congressional_districts"][0]["current_legislators"][0]["type"]).to eq("representative")
    expect(geocodio.geocode(address_sample, appended_fields)["results"][0]["fields"]["congressional_districts"][0]["name"]).to eq("Congressional District 8")
    expect(geocodio.geocode(address_sample, appended_fields)["results"][0]["fields"]["school_districts"]["unified"]["name"]).to eq("Arlington County Public Schools")
    expect(geocodio.geocode(address_sample, appended_fields)["results"][0]["fields"]["school_districts"]["unified"]["grade_high"]).to eq("12")
  end

  it "#geocode can limit amount of responses", vcr: { record: :new_episodes } do
    address_sample = ["1109 N Highland St, Arlington, VA 22201"]
    multi_address_sample = ["1120 N Highland St, Arlington, VA 22201"]
    appended_fields = ["school", "cd"]

    expect(geocodio.geocode(address_sample, appended_fields, 1)["results"].length).to eq(1)
    expect(geocodio.geocode(multi_address_sample, appended_fields, 4)["results"].length).to eq(4)
    expect(geocodio.geocode(multi_address_sample, appended_fields, nil)["results"].length).to eq(6)
  end

  it "#geocode can return simple format", vcr: { record: :new_episodes } do
    address_sample = ["1109 N Highland St, Arlington, VA 22201"]
    second_sample = ["1120 N Highland St, Arlington, VA 22201"]

    expect(geocodio.geocode(address_sample, [], nil, "simple")["address"]).to eq(address_sample.join(""))
    expect(geocodio.geocode(second_sample, [], nil, "simple")["address"]).to eq(second_sample.join(""))
  end

  it "reverse geocodes coordinates", vcr: { record: :new_episodes } do
    coords_sample = ["38.9002898,-76.9990361"]

    expect(geocodio.reverse(coords_sample)["results"][0]["address_components"]["number"]).to eq("508")
    expect(geocodio.reverse(coords_sample)["results"][0]["location"]).to eq({"lat"=>38.900432, "lng"=>-76.999031})
    expect(geocodio.reverse(coords_sample)["results"][0]["formatted_address"]).to eq("508 H St NE, Washington, DC 20002")
  end

  it "appends fields to coordinates", vcr: { record: :new_episodes } do
    coords_sample = ["38.9002898,-76.9990361"]
    appended_fields = ["school", "cd"]

    expect(geocodio.reverse(coords_sample, appended_fields)["results"][0]["fields"]["school_districts"]["unified"]["name"]).to eq("District of Columbia Public Schools")
    expect(geocodio.reverse(coords_sample, appended_fields)["results"][0]["fields"]["congressional_districts"][0]["district_number"]).to eq(98)
    expect(geocodio.reverse(coords_sample, appended_fields)["results"][0]["fields"]["congressional_districts"][0]["current_legislators"][0]["type"]).to eq("representative")
  end

  it "#reverse can limit amount of responses", vcr: { record: :new_episodes } do
    coords_sample = ["38.9002898,-76.9990361"]
    appended_fields = ["school", "cd"]

    expect(geocodio.reverse(coords_sample, appended_fields, 1)["results"].length).to eq(1)
    expect(geocodio.reverse(coords_sample, appended_fields, 4)["results"].length).to eq(4)
    expect(geocodio.reverse(coords_sample, [], 8)["results"].length).to eq(5)
    expect(geocodio.reverse(coords_sample, [], nil)["results"].length).to eq(5)
  end

  it "#reverse can return simple format", vcr: { record: :new_episodes } do
    coords_sample = ["38.9002898,-76.9990361"]
    coords_two = ["38.92977415631741,-77.04941962147353"]

    expect(geocodio.reverse(coords_sample, [], nil, "simple")["address"]).to eq("508 H St NE, Washington, DC 20002")
    expect(geocodio.reverse(coords_two, [], nil, "simple")["address"]).to eq("2269 Cathedral Ave NW, Washington, DC 20008")
  end

  it "batch geocodes multiple addresses", vcr: { record: :new_episodes } do
    batch_addresses = [
      "1109 N Highland St, Arlington, VA 22201",
      "12187 Darnestown Rd, Gaithersburg, MD 20878",
      "4961 Elm Street, Bethesda, MD"
    ]

    expect(geocodio.geocode(batch_addresses)["results"].size).to equal(batch_addresses.size)
    expect(geocodio.geocode(batch_addresses)["results"][0]["response"]["input"]["formatted_address"]).to eq("1109 N Highland St, Arlington, VA 22201")
    expect(geocodio.geocode(batch_addresses)["results"][1]["response"]["input"]["formatted_address"]).to eq("12187 Darnestown Rd, Gaithersburg, MD 20878")
    expect(geocodio.geocode(batch_addresses)["results"][2]["response"]["input"]["formatted_address"]).to eq("4961 Elm St, Bethesda, MD")
  end

  it "reverse geocodes batch coordinates", vcr: { record: :new_episodes } do
    batch_coordinates = [
      "38.88674717512318, -77.09464642536076",
      "39.118308110111954, -77.2516753863881",
      "38.98237295882022, -77.09805507289941"
    ]

    expect(geocodio.reverse(batch_coordinates)["results"].size).to equal(batch_coordinates.size)
    expect(geocodio.reverse(batch_coordinates)["results"][0]["response"]["results"][0]["location"]).to eq({"lat"=>38.886672, "lng"=>-77.094735})
    expect(geocodio.reverse(batch_coordinates)["results"][1]["response"]["results"][0]["location"]).to eq({"lat"=>39.118305, "lng"=>-77.251728})
    expect(geocodio.reverse(batch_coordinates)["results"][2]["response"]["results"][0]["location"]).to eq({"lat"=>38.982397, "lng"=>-77.097998})
  end

  it "creates list from file", vcr: { record: :new_episodes } do
    file = "sample_list_test.csv"
    file_two = "lat_long_test.csv"
    path = File.read(file)
    path_two = File.read(file_two)
    filename = "sample_list_test.csv"
    filename_two = "lat_long_test.csv"
    format = "{{A}} {{B}} {{C}} {{D}}"
    format_two = "{{A}} {{B}}"

    response = geocodio.createList(
      path,
      filename,
      "forward",
      format,
      'http://localhost'
    )

    expect(response["file"]["filename"]).to eq(filename)
    expect(response["file"]["estimated_rows_count"]).to eq(24)

    response = geocodio.createList(
      path_two,
      filename_two,
      "forward",
      format_two,
      'http://localhost'
    )
    expect(response["file"]["filename"]).to eq(filename_two)
    expect(response["file"]["estimated_rows_count"]).to eq(19)
  end

  it "gets list using ID", vcr: { record: :new_episodes } do
    file = "sample_list_test.csv"
    path = File.read(file)
    filename = "sample_list_test.csv"
    format = "{{A}} {{B}} {{C}} {{D}}"

    response = geocodio.createList(
      path,
      filename,
      "forward",
      format,
      'http://localhost'
    )

    expect(geocodio.getList(response["id"])["id"]).to be(response["id"])
  end

  it "gets all lists", vcr: { record: :new_episodes } do
    expect(geocodio.getAllLists.size).to be(9)
    expect(geocodio.getAllLists["current_page"]).to eq(1)
  end

  it "downloads a processing list", vcr: { record: :new_episodes } do
    file = "sample_list_test.csv"
    path = File.read(file)
    filename = "sample_list_test.csv"
    format = "{{A}} {{B}} {{C}} {{D}}"

    response = geocodio.createList(
      path,
      filename,
      "forward",
      format,
      'http://localhost'
    )

    download = geocodio.downloadList(response["id"])

    expect(download["success"]).to eq(false)
  end

  it "downloads a complete list", vcr: { record: :new_episodes} do
    # Requires a list ID that has already been uploaded and processed
    download_complete = geocodio.downloadList(12040486)

    # First cell in spreadsheet returns unprintable character, so testing against other cells.
    expect(download_complete[0][1]).to eq("city")
    expect(download_complete[1][1]).to eq("Washington")
  end

  it "deletes a list", vcr: { record: :new_episodes } do
    # Requires a list ID that has already been uploaded and processed
    expect(geocodio.deleteList(12040486)["success"]).to be(true)
  end
end
