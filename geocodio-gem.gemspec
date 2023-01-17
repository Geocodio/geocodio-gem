# frozen_string_literal: true

require_relative "lib/geocodio/gem/version"

Gem::Specification.new do |spec|
  spec.name = "geocodio-gem"
  spec.version = Geocodio::VERSION
  spec.authors = ["GoldenPavilion"]
  spec.email = ["cory@geocod.io"]

  spec.summary = "Geocodio Ruby Library."
  spec.description = "A Ruby Gem to help you integrate your application with the Geocodio API."
  spec.homepage = "https://www.geocod.io/docs"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://example.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/Geocodio/geocodio-gem/"
  spec.metadata["changelog_uri"] = "https://www.github.com/Geocodio/geocodio-gem/CHANGELOD.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday-follow_redirects"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
