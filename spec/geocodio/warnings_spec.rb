# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

# Warnings passthrough
#
# The API reports non-fatal advisories under a `_warnings` key -- an
# unrecognized field name, a superseded API version, an append that was
# skipped. The gem returns parsed responses verbatim, so the key is already
# available to callers. These specs lock that in: they fail if a future
# typed-response refactor drops the key on any response shape.
#
# The shapes are the ones the OpenAPI specification models (see the
# `Warnings` schema): top-level on single geocode/reverse, per result, per
# batch item, and on the lists and distance-jobs responses.
RSpec.describe Geocodio::Gem, "warnings" do
  let(:geocodio) { Geocodio::Gem.new("test-key") }

  around do |example|
    VCR.turned_off { example.run }
  end

  def stub_api(method, path, payload, status: 200)
    stub_request(method, %r{\Ahttps://api\.geocod\.io/v2/#{Regexp.escape(path)}(\?|\z)})
      .to_return(status: status, body: payload.to_json, headers: { "Content-Type" => "application/json" })
  end

  describe "geocoding responses" do
    it "preserves top-level warnings on a single forward geocode" do
      stub_api(:get, "geocode", {
        "results" => [{ "formatted_address" => "1109 N Highland St, Arlington, VA 22201" }],
        "_warnings" => ["The field congress is not recognized. Did you mean cd?"]
      })

      response = geocodio.geocode(["1109 N Highland St, Arlington VA"], ["congress"])

      expect(response).to have_key("_warnings")
      expect(response["_warnings"]).to eq(["The field congress is not recognized. Did you mean cd?"])
    end

    it "preserves top-level warnings on a single reverse geocode" do
      stub_api(:get, "reverse", {
        "results" => [{ "formatted_address" => "1109 N Highland St, Arlington, VA 22201" }],
        "_warnings" => ["Ignoring parameter zipcode as it was not expected. Did you mean postal_code?"]
      })

      response = geocodio.reverse(["38.886665,-77.094733"])

      expect(response["_warnings"]).to eq(["Ignoring parameter zipcode as it was not expected. Did you mean postal_code?"])
    end

    it "preserves per-result warnings" do
      stub_api(:get, "geocode", {
        "results" => [{
          "formatted_address" => "Arlington, VA 22201",
          "accuracy_type" => "place",
          "_warnings" => ["ffiec field was skipped since result is not street-level"]
        }]
      })

      response = geocodio.geocode(["22201"], ["ffiec"])

      expect(response["results"][0]["_warnings"]).to eq(["ffiec field was skipped since result is not street-level"])
    end

    it "preserves per-item warnings on a batch forward geocode" do
      warning = "The field congress is not recognized. Did you mean cd?"
      stub_api(:post, "geocode", {
        "results" => [
          {
            "query" => "1109 N Highland St, Arlington VA",
            "response" => {
              "results" => [{ "formatted_address" => "1109 N Highland St, Arlington, VA 22201" }],
              "_warnings" => [warning]
            }
          },
          {
            "query" => "525 University Ave, Toronto, ON, Canada",
            "response" => {
              "results" => [{ "formatted_address" => "525 University Ave, Toronto, ON M5G" }],
              "_warnings" => [warning]
            }
          }
        ]
      })

      response = geocodio.geocode(
        ["1109 N Highland St, Arlington VA", "525 University Ave, Toronto, ON, Canada"],
        ["congress"]
      )

      expect(response["results"][0]["response"]["_warnings"]).to eq([warning])
      expect(response["results"][1]["response"]["_warnings"]).to eq([warning])
    end

    it "preserves per-item warnings on a batch reverse geocode" do
      stub_api(:post, "reverse", {
        "results" => [
          {
            "query" => "35.9746000,-77.9658000",
            "response" => {
              "results" => [{ "formatted_address" => "101 W Washington St, Nashville, NC 27856" }],
              "_warnings" => ["There is a newer API version available, please consider upgrading to v2."]
            }
          },
          {
            "query" => "38.886665,-77.094733",
            "response" => {
              "results" => [{ "formatted_address" => "1109 N Highland St, Arlington, VA 22201" }]
            }
          }
        ]
      })

      response = geocodio.reverse(["35.9746000,-77.9658000", "38.886665,-77.094733"])

      expect(response["results"][0]["response"]["_warnings"])
        .to eq(["There is a newer API version available, please consider upgrading to v2."])
      expect(response["results"][1]["response"]).not_to have_key("_warnings")
    end

    it "does not invent a warnings key when the API sends none" do
      stub_api(:get, "geocode", {
        "results" => [{ "formatted_address" => "1109 N Highland St, Arlington, VA 22201" }]
      })

      response = geocodio.geocode(["1109 N Highland St, Arlington VA"])

      expect(response).not_to have_key("_warnings")
      expect(response.fetch("_warnings", [])).to eq([])
    end
  end

  describe "lists responses" do
    it "preserves warnings when creating a list" do
      stub_api(:post, "lists", {
        "id" => 42,
        "file" => { "filename" => "sample_list_test.csv" },
        "_warnings" => ["The following field was not recognized and has been skipped: congressional_district"]
      })

      response = geocodio.createList("sample_list_test.csv", "sample_list_test.csv", "forward", "{{A}}")

      expect(response["_warnings"])
        .to eq(["The following field was not recognized and has been skipped: congressional_district"])
    end

    it "preserves warnings on list status" do
      stub_api(:get, "lists/42", {
        "id" => 42,
        "status" => { "state" => "COMPLETED" },
        "_warnings" => ["The fields parameter should contain a comma-separated list of fields instead of an array"]
      })

      expect(geocodio.getList(42)["_warnings"])
        .to eq(["The fields parameter should contain a comma-separated list of fields instead of an array"])
    end

    it "preserves warnings when listing all lists" do
      stub_api(:get, "lists", {
        "data" => [],
        "_warnings" => ["The fields parameter should contain a comma-separated list of fields instead of an array"]
      })

      expect(geocodio.getAllLists["_warnings"])
        .to eq(["The fields parameter should contain a comma-separated list of fields instead of an array"])
    end
  end

  describe "distance matrix job responses" do
    it "preserves warnings when creating a job" do
      stub_api(:post, "distance-jobs", {
        "id" => 7,
        "identifier" => "dmj_abc123",
        "status" => "ENQUEUED",
        "_warnings" => ["There is a newer API version available, please consider upgrading to v2."]
      })

      response = geocodio.createDistanceMatrixJob("Store coverage", ["38.886665,-77.094733"], ["38.897675,-77.036547"])

      expect(response["_warnings"]).to eq(["There is a newer API version available, please consider upgrading to v2."])
    end

    it "preserves warnings on job status" do
      stub_api(:get, "distance-jobs/dmj_abc123", {
        "data" => { "identifier" => "dmj_abc123", "status" => "COMPLETED" },
        "_warnings" => ["The fields parameter should contain a comma-separated list of fields instead of an array"]
      })

      expect(geocodio.distanceMatrixJobStatus("dmj_abc123")["_warnings"])
        .to eq(["The fields parameter should contain a comma-separated list of fields instead of an array"])
    end

    it "preserves warnings when listing jobs" do
      stub_api(:get, "distance-jobs", {
        "data" => [],
        "_warnings" => ["The fields parameter should contain a comma-separated list of fields instead of an array"]
      })

      expect(geocodio.distanceMatrixJobs["_warnings"])
        .to eq(["The fields parameter should contain a comma-separated list of fields instead of an array"])
    end
  end

  describe "error responses" do
    # The gem does not raise on non-2xx responses; it returns the parsed error
    # body, which carries `_warnings` the same way a successful response does.
    it "preserves warnings attached to an error response" do
      stub_api(:get, "geocode", {
        "error" => "Could not geocode address. Postal code or city required.",
        "_warnings" => ["The field congress is not recognized. Did you mean cd?"]
      }, status: 422)

      response = geocodio.geocode(["1109 N Highland St"], ["congress"])

      expect(response["error"]).to eq("Could not geocode address. Postal code or city required.")
      expect(response["_warnings"]).to eq(["The field congress is not recognized. Did you mean cd?"])
    end
  end
end
