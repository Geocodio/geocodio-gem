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
    results = 
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
