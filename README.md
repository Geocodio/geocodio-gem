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

Forward geocode a single address or batch addresses by using the `Geocodio::Gem#geocode` method. Pass in an array of addresses. If that array contains more than one address, we will automatically trigger the batch option for you. We will parse the provided addresses and return a set of coordinates to you. Your results will return the most accurate locations first. 

```ruby
geocodio.geocode(["1109 N Highland St, Arlington, VA 22201"])
# => {"input"=>{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201"}, "results"=>[{"address_components"=>{"number"=>"1109", "predirectional"=>"N", "street"=>"Highland", "suffix"=>"St", "formatted_street"=>"N Highland St", "city"=>"Arlington", "county"=>"Arlington County", "state"=>"VA", "zip"=>"22201", "country"=>"US"}, "formatted_address"=>"1109 N Highland St, Arlington, VA 22201", "location"=>{"lat"=>38.886672, "lng"=>-77.094735}, "accuracy"=>1, "accuracy_type"=>"rooftop", "source"=>"Arlington"}]}
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
