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
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/Geocodio/geocodio-gem/"
  spec.metadata["changelog_uri"] = "https://www.github.com/Geocodio/geocodio-gem/CHANGELOG.md"

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

  # Runtime dependencies.
  # faraday: pinned to >= 2.14.3 to address CVE-2026-54297 (uncontrolled
  # recursion in NestedParamsEncoder allowing stack-exhaustion DoS). The fix
  # first landed in the 2.x line at 2.14.3, which requires Ruby >= 3.0.
  spec.add_dependency "faraday", ">= 2.14.3"
  spec.add_dependency "faraday-follow_redirects", ">= 0.3.0"
  # csv is required at runtime (see lib/geocodio/gem.rb). It stopped being a
  # default gem in Ruby 3.4, so it must be declared explicitly now that this
  # gem supports Ruby 3.0+.
  spec.add_dependency "csv", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
