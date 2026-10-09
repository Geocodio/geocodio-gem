# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

# The Distance API's `calculation_type` option chooses between a full matrix
# (every origin against every destination, the default) and one-to-one pairs
# (origin i against destination i only). These specs stub the API so they
# never hit it, and check what the gem puts in the JSON request body.
RSpec.describe Geocodio::Gem, "distance calculation type" do
  let(:geocodio) { Geocodio::Gem.new("test-key") }
  let(:origins) { ["38.8977,-77.0365,home", "38.886672,-77.094735,office"] }
  let(:destinations) { ["38.9072,-77.0369,capitol", "38.8895,-77.0353,monument"] }

  around do |example|
    VCR.turned_off { example.run }
  end

  def stub_api(path)
    stub_request(:post, %r{\Ahttps://api\.geocod\.io/v2/#{Regexp.escape(path)}(\?|\z)})
      .to_return(status: 200, body: {}.to_json, headers: { "Content-Type" => "application/json" })
  end

  def request_to(path, &body_matches)
    a_request(:post, %r{\Ahttps://api\.geocod\.io/v2/#{Regexp.escape(path)}(\?|\z)})
      .with { |request| body_matches.call(JSON.parse(request.body)) }
  end

  describe "#distanceMatrix" do
    before { stub_api("distance-matrix") }

    it "sends calculation_type when provided" do
      geocodio.distanceMatrix(origins, destinations, calculation_type: "pairs")

      expect(request_to("distance-matrix") { |body| body["calculation_type"] == "pairs" }).to have_been_made.once
    end

    it "accepts a symbol" do
      geocodio.distanceMatrix(origins, destinations, calculation_type: :matrix)

      expect(request_to("distance-matrix") { |body| body["calculation_type"] == "matrix" }).to have_been_made.once
    end

    it "omits calculation_type when not provided" do
      geocodio.distanceMatrix(origins, destinations)

      expect(request_to("distance-matrix") { |body| !body.key?("calculation_type") }).to have_been_made.once
    end
  end

  describe "#createDistanceMatrixJob" do
    before { stub_api("distance-jobs") }

    it "sends calculation_type when provided" do
      geocodio.createDistanceMatrixJob("Commutes", origins, destinations, calculation_type: "pairs")

      expect(request_to("distance-jobs") { |body| body["calculation_type"] == "pairs" }).to have_been_made.once
    end

    it "omits calculation_type when not provided" do
      geocodio.createDistanceMatrixJob("Commutes", origins, destinations)

      expect(request_to("distance-jobs") { |body| !body.key?("calculation_type") }).to have_been_made.once
    end
  end
end
