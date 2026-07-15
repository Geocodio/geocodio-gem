# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in geocodio-gem.gemspec
gemspec

gem "rake", "~> 13.0"

#TESTING
gem "rspec", "~> 3.0"
gem "webmock"
gem "vcr"
# base64 stopped being a default gem in Ruby 3.4; vcr requires it at load time.
gem "base64"

# NOTE: faraday and faraday-follow_redirects are declared as runtime
# dependencies in geocodio-gem.gemspec (faraday >= 2.14.3 for CVE-2026-54297).

#DEBUGGING
gem "byebug"
gem "pry"

#ENV
gem "dotenv"