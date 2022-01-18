source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 7.0.0"
gem "sprockets-rails"
gem "pg", "~> 1.2.3"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'will_paginate', '~> 3.3.0'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'sassc-rails', '>= 2.1.0'
gem 'jquery-rails'
gem 'factory_bot_rails', "~> 6.2"
gem 'faker', '~> 2.19.0'
gem 'devise', '~> 4.8.1'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]#
  gem 'rspec-rails', '~> 4.0.2'
  gem 'pry-byebug', '~> 3.9'
end

group :development do
  gem "web-console"
  gem 'rubocop', '~> 1.23', require: false
  gem 'rubocop-rspec', '~> 2.6', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 4.0'
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
