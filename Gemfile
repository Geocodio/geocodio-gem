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
# public_suffix (pulled in transitively via webmock -> addressable) dropped
# Ruby < 3.2 support in 7.0. Cap it so the test toolchain still installs on the
# Ruby 3.0/3.1 end of our support matrix. Not security-relevant — the
# addressable advisory is fixed in addressable itself (>= 2.9.0).
gem "public_suffix", "< 7.0"

# NOTE: faraday and faraday-follow_redirects are declared as runtime
# dependencies in geocodio-gem.gemspec (faraday >= 2.14.3 for CVE-2026-54297).

#DEBUGGING
gem "byebug"
gem "pry"

#ENV
gem "dotenv"