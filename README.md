# Geocodio::Gem

Geocodio Gem is a library that allows you to make quick and easy API calls to the [geocod.io](https://geocod.io) API.  
## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add geocodio-gem

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install geocodio-gem

## Usage

To get started, initialize a Geocodio::Gem class by passing in your API Key. If you need to generate an API Key, you can do so by logging into your Geocodio account and navigating to the [API Keys](https://dash.geocod.io/apikey) tab.

```ruby
geocodio = Geocodio::Gem.new("YOUR_API_KEY")
```

### Geocoding

Forward geocoding takes an address and returns coordinates. Geocode a single address by using the `Geocodio::Gem#geocode` method. Pass in an address string within array brackets. We will parse the provided address and respond with a set of coordinates. Your results will return the most accurate locations first. 

```ruby
results = geocodio.geocode(["1109 N Highland St, Arlington, VA 22201"])
# => {"input"=>{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201"}, "results"=>[{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.886672, "lng"=>-77.094735}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Arlington"}]}
```

To batch geocode a group of addresses, pass multiple address strings into the array. The Gem will automatically recognize the batch request and make the appropriate call. 

```ruby
results = geocodio.geocode(["1109 N Highland St, Arlington, VA 22201", "12187 Darnestown Rd, Gaithersburg, MD 20878", "4961 Elm Street, Bethesda, MD"])
# => {"results"=>[{"query"=>"1109 N Highland St, Arlington, VA 22201", "response"=>{"input"=>{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201"}, "results"=>[{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.886672, "lng"=>-77.094735}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Arlington"}]}}, {"query"=>"12187 Darnestown Rd, Gaithersburg, MD 20878", "response"=>{"input"=>{"address_components"=>{"number"=>"12187", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12187 Darnestown Rd, Gaithersburg, MD 20878"}, "results"=>[{"address_components"=>{"number"=>"12187", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12187 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118169, "lng"=>-77.251699}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12185", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12185 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118093, "lng"=>-77.25167}, "accuracy"=>0.9, "accuracy_type"=>"nearest_rooftop_match", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12189", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12189 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118248, "lng"=>-77.251722}, "accuracy"=>0.9, "accuracy_type"=>"nearest_rooftop_match", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12183", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12183 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.117998, "lng"=>-77.25164}, "accuracy"=>0.9, "accuracy_type"=>"nearest_rooftop_match", "source"=>"Montgomery"}]}}, {"query"=>"4961 Elm Street, Bethesda, MD", "response"=>{"input"=>{"address_components"=>{"number"=>"4961", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "state"=>"MD", "country"=>"US"}, "formatted_address"=>"4961 Elm St, Bethesda, MD"}, "results"=>[{"address_components"=>{"number"=>"4961", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4961 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982196, "lng"=>-77.098161}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"4959", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4959 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982198, "lng"=>-77.098084}, "accuracy"=>0.9, "accuracy_type"=>"nearest_rooftop_match", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"4963", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4963 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.98239, "lng"=>-77.097993}, "accuracy"=>0.9, "accuracy_type"=>"nearest_rooftop_match", "source"=>"Statewide MD"}, {"address_components"=>{"number"=>"4963", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4963 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982195, "lng"=>-77.098244}, "accuracy"=>0.9, "accuracy_type"=>"nearest_rooftop_match", "source"=>"Montgomery"}]}}]}
```

### Reverse Geocoding

Reverse geocoding takes a pair of coordinates and returns an address. Reverse geocode a single address by using the `Geocodio::Gem#reverse` method. Pass in a string that contains latitude and longitude separate by a comma. We will respond with an address associated with the coordinates. Your results will return the most accurate locations first.

```ruby
    results = geocodio.reverse(["38.9002898,-76.9990361"])
    # => {"results"=>[{"address_components"=>{"number"=>"508", "street"=>"H", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"H St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"508 H St NE, Washington, DC 20002", "location"=>{"lat"=>38.900432, "lng"=>-76.999031}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Statewide DC"}, {"address_components"=>{"number"=>"510", "street"=>"H", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"H St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"510 H St NE, Washington, DC 20002", "location"=>{"lat"=>38.900429, "lng"=>-76.998965}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Statewide DC"}, {"address_components"=>{"number"=>"506", "street"=>"H", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"H St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"506 H St NE, Washington, DC 20002", "location"=>{"lat"=>38.900437, "lng"=>-76.999099}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Statewide DC"}, {"address_components"=>{"number"=>"504", "street"=>"H", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"H St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"504 H St NE, Washington, DC 20002", "location"=>{"lat"=>38.900422, "lng"=>-76.999169}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Statewide DC"}, {"address_components"=>{"number"=>"512", "street"=>"H", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"H St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"512 H St NE, Washington, DC 20002", "location"=>{"lat"=>38.900435, "lng"=>-76.998897}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Statewide DC"}, {"address_components"=>{"number"=>"500", "street"=>"H", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"H St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"500 H St NE, Washington, DC 20002", "location"=>{"lat"=>38.900203, "lng"=>-76.999507}, "accuracy"=>0.46, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"800", "street"=>"5th", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"5th St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"800 5th St NE, Washington, DC 20002", "location"=>{"lat"=>38.900203, "lng"=>-76.999507}, "accuracy"=>0.46, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"817", "street"=>"6th", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"6th St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"817 6th St NE, Washington, DC 20002", "location"=>{"lat"=>38.900203, "lng"=>-76.998442}, "accuracy"=>0.45, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"774", "street"=>"6th", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"6th St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"774 6th St NE, Washington, DC 20002", "location"=>{"lat"=>38.900078, "lng"=>-76.998443}, "accuracy"=>0.45, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"474", "street"=>"H", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"H St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"474 H St NE, Washington, DC 20002", "location"=>{"lat"=>38.900205, "lng"=>-76.99994}, "accuracy"=>0.44, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"540", "street"=>"I", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"I St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"540 I St NE, Washington, DC 20002", "location"=>{"lat"=>38.901323, "lng"=>-76.998836}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"900", "street"=>"5th", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"5th St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"900 5th St NE, Washington, DC 20002", "location"=>{"lat"=>38.901323, "lng"=>-76.999509}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"900", "street"=>"6th", "suffix"=>"St", "postdirectional"=>"NE", "formatted_street"=>"6th St NE", "city"=>"Washington", "county"=>"District of Columbia", "state"=>"DC", "zip"=>"20002", "country"=>"US"}, "formatted_address"=>"900 6th St NE, Washington, DC 20002", "location"=>{"lat"=>38.901323, "lng"=>-76.998446}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}]}
```

To batch geocode a multiple sets of coordinates, pass each latitude and longitude pair as a separate string into the array. The Gem will automatically recognize the batch request and make the appropriate call.

```ruby
    results = geocode.reverse(["38.88674717512318, -77.09464642536076", "39.118308110111954, -77.2516753863881", "38.98237295882022, -77.09805507289941"])

    # => {"results"=>[{"query"=>"38.88674717512318, -77.09464642536076", "response"=>{"results"=>[{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.886672, "lng"=>-77.094735}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Arlington"}, {"address_components"=>{"number"=>"3030", "street"=>"Clarendon", "suffix"=>"Blvd", "formatted_street"=>"Clarendon Blvd", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"3030 Clarendon Blvd, Arlington, VA 22201", "location"=>{"lat"=>38.886876, "lng"=>-77.094702}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Arlington"}, {"address_components"=>{"number"=>"3020", "street"=>"Clarendon", "suffix"=>"Blvd", "formatted_street"=>"Clarendon Blvd", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"3020 Clarendon Blvd, Arlington, VA 22201", "location"=>{"lat"=>38.886969, "lng"=>-77.094529}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Virginia Geographic Information Network (VGIN)"}, {"address_components"=>{"number"=>"3108", "predirectional"=>"N", "street"=>"Washington", "suffix"=>"Blvd", "formatted_street"=>"N Washington Blvd", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"3108 N Washington Blvd, Arlington, VA 22201", "location"=>{"lat"=>38.885773, "lng"=>-77.094955}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"1027", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1027 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.885598, "lng"=>-77.09476}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"3059", "predirectional"=>"N", "street"=>"Washington", "suffix"=>"Blvd", "formatted_street"=>"N Washington Blvd", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"3059 N Washington Blvd, Arlington, VA 22201", "location"=>{"lat"=>38.885574, "lng"=>-77.09456}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"1079", "predirectional"=>"N", "street"=>"Hudson", "suffix"=>"St", "formatted_street"=>"N Hudson St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1079 N Hudson St, Arlington, VA 22201", "location"=>{"lat"=>38.885785, "lng"=>-77.095693}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"3100", "street"=>"10th", "suffix"=>"Rd", "postdirectional"=>"N", "formatted_street"=>"10th Rd N", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"3100 10th Rd N, Arlington, VA 22201", "location"=>{"lat"=>38.8852, "lng"=>-77.094709}, "accuracy"=>0.42, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"1015", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1015 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.885058, "lng"=>-77.094687}, "accuracy"=>0.41, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"1014", "predirectional"=>"N", "street"=>"Hudson", "suffix"=>"St", "formatted_street"=>"N Hudson St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1014 N Hudson St, Arlington, VA 22201", "location"=>{"lat"=>38.884985, "lng"=>-77.095586}, "accuracy"=>0.41, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"3201", "street"=>"Washington", "suffix"=>"Blvd", "formatted_street"=>"Washington Blvd", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"3201 Washington Blvd, Arlington, VA 22201", "location"=>{"lat"=>38.885989, "lng"=>-77.096909}, "accuracy"=>0.41, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}]}}, {"query"=>"39.118308110111954, -77.2516753863881", "response"=>{"results"=>[{"address_components"=>{"number"=>"12191", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12191 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118326, "lng"=>-77.251749}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12189", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12189 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118248, "lng"=>-77.251722}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12193", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12193 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118376, "lng"=>-77.251707}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12187", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12187 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118169, "lng"=>-77.251699}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12185", "street"=>"Darnestown", "suffix"=>"Rd", "formatted_street"=>"Darnestown Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12185 Darnestown Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.118093, "lng"=>-77.25167}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"12184", "street"=>"State Hwy 28", "formatted_street"=>"State Hwy 28", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12184 State Hwy 28, Gaithersburg, MD 20878", "location"=>{"lat"=>39.117781, "lng"=>-77.252536}, "accuracy"=>0.44, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"15998", "street"=>"Quince Orchard", "suffix"=>"Rd", "formatted_street"=>"Quince Orchard Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"15998 Quince Orchard Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.117888, "lng"=>-77.25293}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"12182", "street"=>"McDonald Chapel", "suffix"=>"Dr", "formatted_street"=>"McDonald Chapel Dr", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12182 McDonald Chapel Dr, Gaithersburg, MD 20878", "location"=>{"lat"=>39.119427, "lng"=>-77.251898}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"15986", "street"=>"Quince Orchard", "suffix"=>"Rd", "formatted_street"=>"Quince Orchard Rd", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"15986 Quince Orchard Rd, Gaithersburg, MD 20878", "location"=>{"lat"=>39.117709, "lng"=>-77.253041}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"12218", "street"=>"State Hwy 28", "formatted_street"=>"State Hwy 28", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12218 State Hwy 28, Gaithersburg, MD 20878", "location"=>{"lat"=>39.117983, "lng"=>-77.253546}, "accuracy"=>0.42, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"12135", "street"=>"McDonald Chapel", "suffix"=>"Dr", "formatted_street"=>"McDonald Chapel Dr", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12135 McDonald Chapel Dr, Gaithersburg, MD 20878", "location"=>{"lat"=>39.119872, "lng"=>-77.25132}, "accuracy"=>0.42, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"1036", "street"=>"State Hwy 124", "formatted_street"=>"State Hwy 124", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"1036 State Hwy 124, Gaithersburg, MD 20878", "location"=>{"lat"=>39.119961, "lng"=>-77.250987}, "accuracy"=>0.41, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"12114", "street"=>"State Hwy 28", "formatted_street"=>"State Hwy 28", "city"=>"Gaithersburg", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20878", "country"=>"US"}, "formatted_address"=>"12114 State Hwy 28, Gaithersburg, MD 20878", "location"=>{"lat"=>39.116996, "lng"=>-77.249917}, "accuracy"=>0.41, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}]}}, {"query"=>"38.98237295882022, -77.09805507289941", "response"=>{"results"=>[{"address_components"=>{"number"=>"4963", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4963 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.98239, "lng"=>-77.097993}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Statewide MD"}, {"address_components"=>{"number"=>"4940", "street"=>"Hampden", "suffix"=>"Ln", "formatted_street"=>"Hampden Ln", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4940 Hampden Ln, Bethesda, MD 20814", "location"=>{"lat"=>38.982529, "lng"=>-77.098032}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"4959", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4959 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982198, "lng"=>-77.098084}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"4957", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4957 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982201, "lng"=>-77.098002}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Montgomery"}, {"address_components"=>{"number"=>"4962", "street"=>"Hampden", "suffix"=>"Ln", "formatted_street"=>"Hampden Ln", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4962 Hampden Ln, Bethesda, MD 20814", "location"=>{"lat"=>38.98247, "lng"=>-77.098252}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Statewide MD"}, {"address_components"=>{"number"=>"4984", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4984 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982093, "lng"=>-77.097887}, "accuracy"=>0.46, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"7300", "street"=>"Arlington", "suffix"=>"Rd", "formatted_street"=>"Arlington Rd", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"7300 Arlington Rd, Bethesda, MD 20814", "location"=>{"lat"=>38.982676, "lng"=>-77.098509}, "accuracy"=>0.46, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"5000", "street"=>"Hampden", "suffix"=>"Ln", "formatted_street"=>"Hampden Ln", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"5000 Hampden Ln, Bethesda, MD 20814", "location"=>{"lat"=>38.982676, "lng"=>-77.098509}, "accuracy"=>0.46, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"7249", "street"=>"Arlington", "suffix"=>"Rd", "formatted_street"=>"Arlington Rd", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"7249 Arlington Rd, Bethesda, MD 20814", "location"=>{"lat"=>38.982036, "lng"=>-77.098479}, "accuracy"=>0.45, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"5000", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"5000 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982036, "lng"=>-77.09848}, "accuracy"=>0.45, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"7400", "street"=>"Arlington", "suffix"=>"Rd", "formatted_street"=>"Arlington Rd", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"7400 Arlington Rd, Bethesda, MD 20814", "location"=>{"lat"=>38.98334, "lng"=>-77.098548}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"4919", "street"=>"Montgomery", "suffix"=>"Ln", "formatted_street"=>"Montgomery Ln", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4919 Montgomery Ln, Bethesda, MD 20814", "location"=>{"lat"=>38.983371, "lng"=>-77.097503}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}, {"address_components"=>{"number"=>"4956", "street"=>"Elm", "suffix"=>"St", "formatted_street"=>"Elm St", "city"=>"Bethesda", "county"=>"Montgomery County", "state"=>"MD", "zip"=>"20814", "country"=>"US"}, "formatted_address"=>"4956 Elm St, Bethesda, MD 20814", "location"=>{"lat"=>38.982138, "lng"=>-77.096655}, "accuracy"=>0.43, "accuracy_type"=>"nearest_street", "source"=>"TIGER/Line® dataset from the US Census Bureau"}]}}]}    
```
### Appending Fields

If you would like to append data fields to your results, you can do so by passing in a second array after the array that contains your addresses or coordinates. Be sure to separate these arrays by a comma. Within the second array, provide a string of the parameter name of the field you would like to append. For example, if you require timezones added to your results, you would use "timezone". 

For a complete list of data field parameters, reference the [Geocodio API documentation](https://www.geocod.io/docs/?shell#fields).

This will work for both the `Geocodio::Gem#geocode` and `Geocodio::Gem#reverse` methods. 

```ruby
   results = geocodio.geocode(["1109 N Highland St, Arlington, VA 22201"], ["timezone"])

   # => {"input"=>{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201"}, "results"=>[{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.886672, "lng"=>-77.094735}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Arlington", "fields"=>{"timezone"=>{"name"=>"America/New_York", "utc_offset"=>-5, "observes_dst"=>true, "abbreviation"=>"EST", "source"=>"© OpenStreetMap contributors"}}}]}
```

If you would like to append multiple data fields, pass each parameter that you require into the array as a separate string, divided by commas. 

```ruby
    results = results = geocodio.geocode(["1109 N Highland St, Arlington, VA 22201"], ["timezone", "stateleg"])

    # => {"input"=>{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201"}, "results"=>[{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.886672, "lng"=>-77.094735}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Arlington", "fields"=>{"state_legislative_districts"=>{"house"=>[{"name"=>"State House District 47", "district_number"=>"47", "ocd_id"=>nil, "is_upcoming_state_legislative_district"=>false, "proportion"=>1}], "senate"=>[{"name"=>"State Senate District 31", "district_number"=>"31", "ocd_id"=>nil, "is_upcoming_state_legislative_district"=>false, "proportion"=>1}]}, "timezone"=>{"name"=>"America/New_York", "utc_offset"=>-5, "observes_dst"=>true, "abbreviation"=>"EST", "source"=>"© OpenStreetMap contributors"}}}]}
``` 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/geocodio-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/geocodio-gem/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Geocodio project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/geocodio-gem/blob/master/CODE_OF_CONDUCT.md).
