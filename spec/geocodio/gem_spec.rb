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
    appended_fields = ["school", "cd"]

    expect(geocodio.geocode(address_sample, appended_fields, 1)["results"].length).to eq(1)
    # Verify that results are limited when limit is specified
    results_with_limit = geocodio.geocode(address_sample, appended_fields, 1)["results"]
    expect(results_with_limit.length).to be <= 1
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
    expect(geocodio.reverse(coords_sample, appended_fields, 4)["results"].length).to be <= 4
    expect(geocodio.reverse(coords_sample, [], 8)["results"].length).to be <= 8
    # Verify that without limit, we get results
    expect(geocodio.reverse(coords_sample, [], nil)["results"].length).to be >= 1
  end

  it "#reverse can return simple format", vcr: { record: :new_episodes } do
    coords_sample = ["38.9002898,-76.9990361"]
    coords_two = ["38.92977415631741,-77.04941962147353"]

    expect(geocodio.reverse(coords_sample, [], nil, "simple")["address"]).to eq("508 H St NE, Washington, DC 20002")
    # API returns nearest address to coordinates - verify we get a valid DC address
    expect(geocodio.reverse(coords_two, [], nil, "simple")["address"]).to include("Washington, DC")
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

  # Skipped: These tests require a pre-existing processed list that may be deleted
  # To re-enable, create a new list via createList, wait for processing, then update the list ID
  xit "downloads a complete list", vcr: { record: :new_episodes} do
    # Requires a list ID that has already been uploaded and processed
    download_complete = geocodio.downloadList(12040486)

    # First cell in spreadsheet returns unprintable character, so testing against other cells.
    expect(download_complete[0][1]).to eq("city")
    expect(download_complete[1][1]).to eq("Washington")
  end

  xit "deletes a list", vcr: { record: :new_episodes } do
    # Requires a list ID that has already been uploaded and processed
    expect(geocodio.deleteList(12040486)["success"]).to be(true)
  end

  # Distance API Tests

  it "calculates distance from single origin to multiple destinations", vcr: { record: :new_episodes } do
    origin = "38.8977,-77.0365,white_house"
    destinations = ["38.9072,-77.0369,capitol", "38.8895,-77.0353,monument"]

    response = geocodio.distance(origin, destinations)

    expect(response["origin"]).not_to be_nil
    expect(response["origin"]["id"]).to eq("white_house")
    expect(response["destinations"]).to be_an(Array)
    expect(response["destinations"].length).to eq(2)
    expect(response["destinations"][0]["distance_miles"]).to be_a(Numeric)
  end

  it "calculates distance with driving mode", vcr: { record: :new_episodes } do
    origin = "38.8977,-77.0365"
    destinations = ["38.9072,-77.0369"]

    response = geocodio.distance(origin, destinations, mode: :driving)

    expect(response["mode"]).to eq("driving")
    expect(response["destinations"][0]["duration_seconds"]).to be_a(Numeric)
  end

  it "calculates distance with different units", vcr: { record: :new_episodes } do
    origin = "38.8977,-77.0365"
    destinations = ["38.9072,-77.0369"]

    response = geocodio.distance(origin, destinations, units: :kilometers)

    expect(response["destinations"][0]["distance_km"]).to be_a(Numeric)
  end

  it "calculates distance with array coordinate format", vcr: { record: :new_episodes } do
    origin = [38.8977, -77.0365, "headquarters"]
    destinations = [[38.9072, -77.0369, "branch_1"]]

    response = geocodio.distance(origin, destinations)

    expect(response["origin"]["id"]).to eq("headquarters")
    expect(response["destinations"][0]["id"]).to eq("branch_1")
  end

  it "calculates distance with hash coordinate format", vcr: { record: :new_episodes } do
    origin = { lat: 38.8977, lng: -77.0365, id: "hq" }
    destinations = [{ lat: 38.9072, lng: -77.0369, id: "branch" }]

    response = geocodio.distance(origin, destinations)

    expect(response["origin"]["id"]).to eq("hq")
    expect(response["destinations"][0]["id"]).to eq("branch")
  end

  it "calculates distance with filtering options", vcr: { record: :new_episodes } do
    origin = "38.8977,-77.0365"
    destinations = ["38.9072,-77.0369", "39.2904,-76.6122", "39.9526,-75.1652"]

    response = geocodio.distance(origin, destinations, max_results: 2, order_by: :distance, sort: :asc)

    expect(response["destinations"].length).to be <= 2
  end

  it "calculates distance matrix", vcr: { record: :new_episodes } do
    origins = ["38.8977,-77.0365,origin_1", "38.9072,-77.0369,origin_2"]
    destinations = ["38.8895,-77.0353,dest_1", "39.2904,-76.6122,dest_2"]

    response = geocodio.distanceMatrix(origins, destinations)

    expect(response["results"]).to be_an(Array)
    expect(response["results"].length).to eq(2)
    expect(response["results"][0]["origin"]["id"]).to eq("origin_1")
    expect(response["results"][0]["destinations"]).to be_an(Array)
  end

  it "calculates distance matrix with driving mode", vcr: { record: :new_episodes } do
    origins = ["38.8977,-77.0365"]
    destinations = ["38.9072,-77.0369"]

    response = geocodio.distanceMatrix(origins, destinations, mode: :driving)

    expect(response["mode"]).to eq("driving")
    expect(response["results"][0]["destinations"][0]["duration_seconds"]).to be_a(Numeric)
  end

  it "creates a distance matrix job", vcr: { record: :new_episodes } do
    origins = ["38.8977,-77.0365,origin_1"]
    destinations = ["38.8895,-77.0353,dest_1"]

    response = geocodio.createDistanceMatrixJob(
      "Test Distance Job",
      origins,
      destinations,
      mode: :straightline,
      callback_url: "https://example.com/webhook"
    )

    expect(response["id"]).not_to be_nil
    expect(response["name"]).to eq("Test Distance Job")
    expect(response["status"]).not_to be_nil
  end

  it "gets distance matrix job status", vcr: { record: :new_episodes } do
    # Create a job first
    origins = ["38.8977,-77.0365"]
    destinations = ["38.8895,-77.0353"]
    job = geocodio.createDistanceMatrixJob("Status Test Job", origins, destinations)

    response = geocodio.distanceMatrixJobStatus(job["id"])

    expect(response["data"]["id"]).to eq(job["id"])
    expect(response["data"]["status"]).not_to be_nil
  end

  it "lists all distance matrix jobs", vcr: { record: :new_episodes } do
    response = geocodio.distanceMatrixJobs

    expect(response).to have_key("data")
    expect(response["data"]).to be_an(Array)
  end

  it "geocodes with distance to destinations", vcr: { record: :new_episodes } do
    address = ["1109 N Highland St, Arlington, VA 22201"]
    destinations = ["38.9072,-77.0369,capitol", "38.8895,-77.0353,monument"]

    response = geocodio.geocode(
      address,
      [],
      nil,
      nil,
      destinations: destinations,
      distance_mode: :straightline
    )

    expect(response["results"][0]["destinations"]).to be_an(Array)
    expect(response["results"][0]["destinations"].length).to eq(2)
  end

  it "reverse geocodes with distance to destinations", vcr: { record: :new_episodes } do
    coords = ["38.9002898,-76.9990361"]
    destinations = ["38.9072,-77.0369,capitol"]

    response = geocodio.reverse(
      coords,
      [],
      nil,
      nil,
      destinations: destinations,
      distance_mode: :driving
    )

    expect(response["results"][0]["destinations"]).to be_an(Array)
  end

  it "maps haversine mode to straightline", vcr: { record: :new_episodes } do
    origin = "38.8977,-77.0365"
    destinations = ["38.9072,-77.0369"]

    response = geocodio.distance(origin, destinations, mode: :haversine)

    expect(response["mode"]).to eq("straightline")
  end
end
